{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.editors.jetbrains;
in
{
  options.features.editors.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDEs.";
    android-studio.enable = lib.mkEnableOption "Android Studio.";
    datagrip.enable = lib.mkEnableOption "DataGrip.";
    rider.enable = lib.mkEnableOption "Rider.";
    clion.enable = lib.mkEnableOption "CLion.";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."ideavim/ideavimrc".source = ../../../../dotfiles/ideavim/ideavimrc;

    home.packages =
      with pkgs;
      lib.optionals cfg.datagrip.enable [ jetbrains.datagrip ]
      ++ lib.optionals cfg.rider.enable [ jetbrains.rider ]
      ++ lib.optionals cfg.clion.enable [ jetbrains.clion ]
      ++ lib.optionals cfg.android-studio.enable [
        android-tools
        android-studio
      ];
  };
}
