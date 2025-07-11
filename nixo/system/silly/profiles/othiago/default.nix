{
  pkgs,
  inputs,
  ...
}:
{
  sharedFolders.configurationRoot = "~/RikaOS";

  desktop.gnome.enable = true;

  nixpkgs.config.allowUnfree = true;
  neovim.enable = true;
  terminal.enable = true;

  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono

  ];

  programs = {
    gh.enable = true;
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    hyfetch = {
      enable = true;
      settings = {
        preset = "bisexual";
        mode = "rgb";
        color_align.mode = "horizontal";
      };
    };
  };
}
