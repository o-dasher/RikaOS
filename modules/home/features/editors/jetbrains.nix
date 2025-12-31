{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
{
  options.editors.jetbrains = with lib; {
    enable = mkEnableOption "JetBrains IDEs configuration";
    android-studio.enable = mkEnableOption "Android Studio";
    datagrip.enable = mkEnableOption "DataGrip";
  };

  config = lib.mkMerge [
    (lib.mkIf config.editors.jetbrains.enable {
      home.file = (
        config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
          "ideavimrc"
        ] { }
      );

      home.packages = lib.mkMerge [
        (lib.mkIf config.editors.jetbrains.android-studio.enable [
          pkgs.android-studio
        ])
        (lib.mkIf config.editors.jetbrains.datagrip.enable [
          pkgs.jetbrains.datagrip
        ])
      ];
    })

    (lib.mkIf
      (config.editors.jetbrains.enable && (osConfig == null || !osConfig.home-manager.useGlobalPkgs))
      {
        nixpkgs.config.android_sdk.accept_license = config.editors.jetbrains.android-studio.enable;
      }
    )
  ];
}
