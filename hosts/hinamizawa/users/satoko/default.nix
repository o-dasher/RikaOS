_: {
  programs.home-manager.enable = true;

  features = {
    terminal.ghostty.enable = true;
    gaming.mangohud.enable = true;
    utilities.trash.enable = true;
    desktop = {
      umbriel.enable = true;
      theme.graduation.enable = true;
    };
    core.xdg = {
      enable = true;
      portal.enable = true;
    };
  };
}
