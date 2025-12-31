{ lib, config, ... }:
let
  gen_css_fn = fn_name: args: "${fn_name}(${args})";
  apply_numeric_css_fn =
    fn_name: property: value:
    gen_css_fn fn_name "${property}, ${toString value}";

in
{
  options.rika.utils = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Utility functions for RikaOS configuration";
  };

  config.rika.utils = {
    selectiveSymLink =
      from: to: paths: opts:
      lib.mkMerge (
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

    css = {
      font_definition = "font-family: 'JetBrains Mono', 'FiraMono Nerd Font';";
      inherit apply_numeric_css_fn;
      alpha_fn = apply_numeric_css_fn "alpha";
      shade_fn = apply_numeric_css_fn "shade";

      tailwindCSS =
        pkgs: colors: content:
        pkgs.runCommand "tailwindify.css"
          {
            nativeBuildInputs = [ pkgs.nodePackages.tailwindcss ];
            tailwindConfig =
              let
                inherit (colors)
                  base00
                  base01
                  base02
                  base03
                  base04
                  base05
                  base06
                  base07
                  base08
                  base09
                  base0A
                  base0B
                  base0C
                  base0D
                  base0E
                  base0F
                  ;
              in
              pkgs.writeText "tailwind.config.js"
                # js
                ''
                  module.exports = {
                    content: ["./input.css"],
                    theme: {
                      extend: {
                        colors: {
                          base00: "#${base00}", base01: "#${base01}", base02: "#${base02}", base03: "#${base03}",
                          base04: "#${base04}", base05: "#${base05}", base06: "#${base06}", base07: "#${base07}",
                          base08: "#${base08}", base09: "#${base09}", base0A: "#${base0A}", base0B: "#${base0B}",
                          base0C: "#${base0C}", base0D: "#${base0D}", base0E: "#${base0E}", base0F: "#${base0F}"
                        }
                      }
                    },
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
          '';
    };
  };
}
