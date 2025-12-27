{
  lib,
  config,
  pkgs,
  ...
}:
{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false;

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-term
    cosmic-edit
    cosmic-files
  ];
}
