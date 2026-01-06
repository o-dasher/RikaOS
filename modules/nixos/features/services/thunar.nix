{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.services.thunar = {
    enable = lib.mkEnableOption "thunar";
  };

  config = lib.mkIf config.features.services.thunar.enable {
    environment.systemPackages = with pkgs; [
      file-roller
      p7zip
    ];
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
      ];
    };
    services = {
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # Thumbnail support for images
    };
  };
}
