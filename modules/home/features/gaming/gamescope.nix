{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.gaming.gamescope;

  baseArgsStr = lib.concatStringsSep " " cfg.args;
  mkGamescopeWrapper =
    args: pkg:
    let
      binName = pkg.meta.mainProgram or (lib.getName pkg);
      argsString = lib.concatStringsSep " " (
        lib.filter (x: x != "") [
          baseArgsStr
          args
        ]
      );
    in
    pkgs.symlinkJoin {
      name = "${pkg.name}-gamescope";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/${binName}
        makeWrapper ${lib.getExe pkgs.gamescope} $out/bin/${binName} \
          --add-flags "${argsString} -- ${lib.getExe pkg}"
      '';
    };
in
{
  options.features.gaming.gamescope = {
    enable = lib.mkEnableOption "gamescope wrapper function";
    args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Default gamescope arguments.";
    };
    wrap = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
    };
    wrapDefault = lib.mkOption {
      type = lib.types.unspecified;
      readOnly = true;
    };
  };

  config = lib.mkIf (config.features.gaming.enable && cfg.enable) {
    features.gaming.gamescope = {
      wrap = mkGamescopeWrapper;
      wrapDefault = mkGamescopeWrapper "";
    };

    home.packages = [
      pkgs.gamescope
      (pkgs.writeShellScriptBin "gamescope-default" ''
        exec ${lib.getExe pkgs.gamescope} ${lib.concatStringsSep " " cfg.args} "$@"
      '')
    ];
  };
}
