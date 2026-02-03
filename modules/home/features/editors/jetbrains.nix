{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
let
  cfg = config.features.editors.jetbrains;
in
{
  options.features.editors.jetbrains = with lib; {
    enable = mkEnableOption "JetBrains IDEs configuration";
    android-studio.enable = mkEnableOption "Android Studio";
    datagrip.enable = mkEnableOption "DataGrip";
    rider.enable = mkEnableOption "Rider";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        file = (
          config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
            "ideavimrc"
          ] { }
        );
        packages =
          with pkgs;
          with jetbrains;
          lib.optionals cfg.android-studio.enable [
            android-tools
            android-studio
          ]
          ++ lib.optionals cfg.datagrip.enable [
            datagrip
          ]
          ++ lib.optionals cfg.rider.enable [
            rider
          ];
      };
    })
    (lib.mkIf (cfg.enable && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)) {
      nixpkgs.config.android_sdk.accept_license = cfg.android-studio.enable;
    })
  ];
}
