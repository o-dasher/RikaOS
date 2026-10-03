{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.hyprland.enable {
    # Ensure PAM service for swaylock is configured in NixOS (/etc/pam.d/swaylock)
    security.pam.services.swaylock = { };

    # Fix xdg-desktop-portal-hyprland startup crash loop / portal hanging.
    # Reference: https://www.reddit.com/r/linuxquestions/comments/1u6iswb/xdgdesktopportalhyprland_broken/
    systemd.user.services.xdg-desktop-portal-hyprland = {
      unitConfig.StartLimitIntervalSec = "0s";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
