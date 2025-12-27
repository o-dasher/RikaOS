{
  pkgs,
  ...
}:
{
  theme.lain.enable = true;

  profiles = {
    gaming.enable = true;
    browser.enable = true;
  };

  # Rika uses Hyprland home-manager module, Satoko uses COSMIC system module (enabled globally via availability)
  # but Satoko wants "no extras", so we don't need a complex home-manager module for COSMIC here unless needed for specific user settings.
  # The system-level cosmic module will provide the session.

  home.packages = with pkgs; [
    # Minimal packages if needed, user said "no extras".
  ];

  programs = {
    home-manager.enable = true;
  };
}
