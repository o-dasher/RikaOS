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

  basePackages = {
    inherit (pkgs) android-studio;
    inherit (pkgs.jetbrains) clion datagrip rider;
  };

  ides =
    if cfg.wayland.enable then
      lib.mapAttrs (_: p: p.override { forceWayland = true; }) basePackages
    else
      basePackages;
in
{
  options.features.editors.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs configuration";
    android-studio.enable = lib.mkEnableOption "Android Studio";
    datagrip.enable = lib.mkEnableOption "DataGrip";
    rider.enable = lib.mkEnableOption "Rider";
    clion.enable = lib.mkEnableOption "Clion";
    wayland.enable = lib.mkEnableOption "Force native Wayland for JetBrains IDEs" // {
      default = true;
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) (
    lib.mkMerge [
      {
        home = {
          file = config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
            "ideavimrc"
          ] { };

          packages =
            lib.optionals cfg.datagrip.enable [ ides.datagrip ]
            ++ lib.optionals cfg.rider.enable [ ides.rider ]
            ++ lib.optionals cfg.clion.enable [ ides.clion ]
            ++ lib.optionals cfg.android-studio.enable [
              pkgs.android-tools
              ides.android-studio
            ];
        };
      }
      (lib.mkIf ((osConfig == null || !osConfig.home-manager.useGlobalPkgs) && cfg.android-studio.enable)
        {
          nixpkgs.config.android_sdk.accept_license = cfg.android-studio.enable;
        }
      )
    ]
  );
}
