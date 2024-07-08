{ ... }:
{
  stylix = {
    autoEnable = false;
    image = ../../../../assets/Wallpapers/purplyu.jpg;

    # We opt-in because gtk theming is broken on gnome?
    targets = {
      tmux.enable = true;
      firefox.enable = true;
      fish.enable = true;
      lazygit.enable = true;
      wezterm.enable = true;
      sway.enable = true;
      waybar.enable = true;
      vim.enable = true;
    };
  };
}
