{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.utilities.enable = lib.mkEnableOption "Utilities profile";

  config = lib.mkIf config.profiles.development.enable {
    programs = {
      htop.enable = true;
      yazi.enable = true;
    };

    home.packages = with pkgs; [
      # general
      gdu
      unzip
      # monitor
      mission-center
      # Disk partitioning
      gparted
    ];
  };
}
