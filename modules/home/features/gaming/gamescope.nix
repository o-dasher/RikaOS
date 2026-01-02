{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming.gamescope;

  wrapWithGamescope =
    args: pkg:
    let
      allArgs = lib.concatStringsSep " " (
        lib.filter (s: s != "") [
          cfg.args
          args
        ]
      );
      binName = pkg.meta.mainProgram or (lib.getName pkg);
    in
    pkgs.runCommand "${pkg.name}-gamescope"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta = pkg.meta // {
          mainProgram = binName;
        };
      }
      ''
        mkdir -p $out/bin
        for f in ${pkg}/bin/*; do
          ln -s "$f" "$out/bin/$(basename "$f")"
        done

        rm $out/bin/${binName}
        makeWrapper ${lib.getExe pkgs.gamescope} $out/bin/${binName} \
          --add-flags "${allArgs} -- ${pkg}/bin/${binName}"

        # Symlink share for desktop files, icons, etc.
        if [ -d "${pkg}/share" ]; then
          ln -s ${pkg}/share $out/share
        fi
      '';
in
{
  options.features.gaming.gamescope = {
    enable = lib.mkEnableOption "gamescope wrapper function";

    args = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Default gamescope arguments applied to all wrapped packages";
      example = "-W 2560 -H 1440 -f -e";
    };

    wrap = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "Function to wrap a package with gamescope: wrap \"extra-args\" pkg";
    };

    wrapDefault = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
      description = "Function to wrap a package with only global args: wrapDefault pkg";
    };
  };

  config = lib.mkIf (config.features.gaming.enable && cfg.enable) {
    home.packages = [ pkgs.gamescope ];

    features.gaming.gamescope.wrap = wrapWithGamescope;
    features.gaming.gamescope.wrapDefault = wrapWithGamescope "";
  };
}
