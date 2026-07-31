{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
with lib;
{
  options.rika = {
    utils = mkOption {
      type = types.attrs;
      default = { };
      description = "Utility functions for RikaOS configuration";
    };
  };

  config.rika.utils = {
    hasSecrets = builtins.hasAttr "gemini-api-key" config.age.secrets;

    mkAutostartApp =
      {
        pkg,
        args ? "",
        command ? "${getExe pkg}${optionalString (args != "") " ${args}"}",
      }:
      let
        hasUWSM = osConfig != null && osConfig.programs.uwsm.enable;
        execCmd = if hasUWSM then command else "${getExe pkgs.app2unit} -- ${command}";
        pkgName = getName pkg;
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
          filePath:
          lib.nameValuePair "${to}/${filePath}" (
            {
              source = config.lib.file.mkOutOfStoreSymlink "${from}/${filePath}";
            }
            // opts
          )
        ) paths
      );

    xdgConfigSelectiveSymLink =
      to: paths: opts:
      config.rika.utils.selectiveSymLink ../../dotfiles/${to} ".config/${to}" paths opts;

    prefixset =
      prefix: kvpairs:
      builtins.mapAttrs (
        name: value: if builtins.typeOf prefix == "lambda" then prefix value else prefix + " " + value
      ) kvpairs;

    css.tailwindCSS =
      content:
      let
        # Filter to only include base16/24 color names (base00-base0F, base10-base17)
        # Excludes derivatives like base00-hex, base00-rgb-r, etc.
        colors = filterAttrs (
          name: _: builtins.match "base[0-1][0-9A-Fa-f]" name != null
        ) config.lib.stylix.colors;
        colorEntries = builtins.concatStringsSep ", " (
          mapAttrsToList (name: value: "${name}: \"#${value}\"") colors
        );
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
