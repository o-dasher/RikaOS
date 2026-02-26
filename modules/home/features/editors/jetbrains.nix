{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.editors;
  cfg = modCfg.jetbrains;
in
with lib;
{
  options.features.editors.jetbrains = {
    enable = mkEnableOption "JetBrains IDEs configuration";
    android-studio.enable = mkEnableOption "Android Studio";
    datagrip.enable = mkEnableOption "DataGrip";
    rider.enable = mkEnableOption "Rider";
  };

  config = mkMerge [
    (mkIf (modCfg.enable && cfg.enable) {
      home = {
        file = (
          config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
            "ideavimrc"
          ] { }
        );
        packages =
          with pkgs;
          with jetbrains;
          optionals cfg.android-studio.enable [
            android-tools
            android-studio
          ]
          ++ optionals cfg.datagrip.enable [
            datagrip
          ]
          ++ optionals cfg.rider.enable [
            rider
          ];
      };
    })
    (mkIf (modCfg.enable && cfg.enable && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)) {
      nixpkgs.config.android_sdk.accept_license = cfg.android-studio.enable;
    })
  ];
}
