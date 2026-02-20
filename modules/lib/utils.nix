{
  lib,
  config,
  pkgs,
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

    mkAutostartService = executable: {
      Unit = {
        Description = "Autostart service for ${executable}";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${executable}";
        Restart = "on-failure";
      };
    };

    selectiveSymLink =
      from: to: paths: opts:
      mkMerge (
        map (filePath: {
          "${to}/${filePath}" = {
            source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath /. + "${from}/${filePath}");
          }
          // opts;
        }) paths
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
            nativeBuildInputs = [ pkgs.nodePackages.tailwindcss ];
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
            ln -s $tailwindConfig tailwind.config.js
            cat > input.css <<EOF
            ${content}
            EOF
            ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i input.css -o $out
          ''
      );
  };
}
