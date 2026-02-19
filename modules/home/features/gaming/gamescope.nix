{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming.gamescope;
in
{
  options.features.gaming.gamescope = {
    enable = lib.mkEnableOption "gamescope wrapper function";

    args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Default gamescope arguments applied to all wrapped packages";
      example = [
        "-w 2560"
        "-h 1440"
      ];
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
    features.gaming.gamescope = rec {
      wrapDefault = wrap "";
      wrap =
        args: pkg:
        let
          allArgs = lib.concatStringsSep " " (cfg.args ++ (lib.optional (args != "") args));
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
    };

    home.packages = with pkgs; [
      gamescope
      (writeShellScriptBin "gamescope-default" ''
        exec ${lib.getExe gamescope} ${lib.concatStringsSep " " cfg.args} "$@"
      '')
    ];
  };
}
