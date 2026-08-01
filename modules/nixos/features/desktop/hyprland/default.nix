{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.hyprland.enable {
    # Ensure PAM service for hyprlock is configured in NixOS (/etc/pam.d/hyprlock)
    security.pam.services.hyprlock = { };

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
