{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
{
  options.features.editors.jetbrains = with lib; {
    enable = mkEnableOption "JetBrains IDEs configuration";
    android-studio.enable = mkEnableOption "Android Studio";
    datagrip.enable = mkEnableOption "DataGrip";
  };

  config = lib.mkMerge [
    (lib.mkIf config.features.editors.jetbrains.enable {
      home.file = (
        config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
          "ideavimrc"
        ] { }
      );

      home.packages =
        with pkgs;
        lib.mkMerge [
          (lib.mkIf config.features.editors.jetbrains.android-studio.enable [
            android-tools
            android-studio
          ])
          (lib.mkIf config.features.editors.jetbrains.datagrip.enable [
            jetbrains.datagrip
          ])
        ];
    })

    (lib.mkIf
      (
        config.features.editors.jetbrains.enable
        && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
      )
      {
        nixpkgs.config.android_sdk.accept_license = config.features.editors.jetbrains.android-studio.enable;
      }
    )
  ];
}
