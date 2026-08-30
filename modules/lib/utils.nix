{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
{
  options = {
    features.filesystem.sharedFolders = {
      enable = lib.mkEnableOption "sharedFolders";
      configurationRoot = lib.mkOption {
        default = "/shared/.config";
        type = lib.types.str;
      };
    };

    rika.utils = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Utility functions for RikaOS configuration";
    };
  };

  config.rika.utils = {
    idleTimers =
      let
        minute = 60;
      in
      {
        lock = 5 * minute;
        dpms = 10 * minute;
        suspend = 30 * minute;
      };

    hasSecrets = builtins.hasAttr "gemini-api-key" config.age.secrets;

    nixAccessTokens = lib.optionalString (config.age.secrets ? nix-access-tokens) ''
      !include ${config.age.secrets.nix-access-tokens.path}
    '';

    mkAutostartApp =
      {
        pkg,
        args ? "",
        command ? "${lib.getExe pkg}${lib.optionalString (args != "") " ${args}"}",
      }:
      let
        hasUWSM = osConfig != null && osConfig.programs.uwsm.enable;
        execCmd = if hasUWSM then command else "${lib.getExe pkgs.app2unit} -- ${command}";
        pkgName = lib.getName pkg;
        desktopItem = pkgs.makeDesktopItem {
          name = pkgName;
          desktopName = pkgName;
          exec = execCmd;
          terminal = false;
          type = "Application";
          noDisplay = true;
        };
      in
      "${desktopItem}/share/applications/${pkgName}.desktop";

    selectiveSymLink =
      from: to: paths: opts:
      builtins.listToAttrs (
        map (
          p:
          lib.nameValuePair "${to}/${p}" (
            { source = config.lib.file.mkOutOfStoreSymlink "${from}/${p}"; } // opts
          )
        ) paths
      );

    xdgConfigSelectiveSymLink =
      to: paths: opts:
      config.rika.utils.selectiveSymLink ../../dotfiles/${to} ".config/${to}" paths opts;

    prefixset =
      prefix: kvpairs:
      builtins.mapAttrs (
        _: v: if builtins.typeOf prefix == "lambda" then prefix v else prefix + " " + v
      ) kvpairs;

    css.tailwindCSS =
      content:
      let
        # Filter to only include base16/24 color names (base00-base0F, base10-base17)
        # Excludes derivatives like base00-hex, base00-rgb-r, etc.
        colors = lib.filterAttrs (
          n: _: builtins.match "base[0-1][0-9A-Fa-f]" n != null
        ) config.lib.stylix.colors;
        colorEntries = builtins.concatStringsSep ", " (lib.mapAttrsToList (n: v: "${n}: \"#${v}\"") colors);
      in
      builtins.readFile (
        pkgs.runCommand "tailwindify.css"
          {
            nativeBuildInputs = [ pkgs.tailwindcss ];
            tailwindConfig =
              pkgs.writeText "tailwind.config.js" # js
                ''
                  module.exports = {
                    content: ["./input.css"],
                    theme: { extend: { colors: { ${colorEntries} } } },
                    plugins: [],
                  }
                '';
          }
          ''
            export BROWSERSLIST_IGNORE_OLD_DATA=1
            ln -s $tailwindConfig tailwind.config.js
            cat > input.css <<EOF
            ${content}
            EOF
            ${lib.getExe pkgs.tailwindcss} -i input.css -o $out
          ''
      );
  };
}
