{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.profiles.security = {
    enable = lib.mkEnableOption "security profile";
  };

  config = lib.mkIf config.profiles.security.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
