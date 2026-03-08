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
    clion.enable = mkEnableOption "Clion";
    wayland.enable = mkEnableOption "Force native Wayland for JetBrains IDEs" // {
      default = true;
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      home = {
        file = config.rika.utils.xdgConfigSelectiveSymLink "ideavim" [
          "ideavimrc"
        ] { };

        packages =
          with pkgs;
          with (
            let
              base =
                genAttrs [
                  "clion"
                  "datagrip"
                  "rider"
                ] (name: pkgs.jetbrains.${name})
                // {
                  inherit (pkgs) android-studio;
                };
            in
            if cfg.wayland.enable then mapAttrs (_: p: p.override { forceWayland = true; }) base else base
          );
          optionals cfg.datagrip.enable [ datagrip ]
          ++ optionals cfg.rider.enable [ rider ]
          ++ optionals cfg.clion.enable [ clion ]
          ++ optionals cfg.android-studio.enable [
            android-tools
            android-studio
          ];
      };
    }
    (mkIf (osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
      nixpkgs.config.android_sdk.accept_license = cfg.android-studio.enable;
    })
  ]);
}
