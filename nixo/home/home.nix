{ inputs, pkgs, ... }:
let
  inherit (import ../common/variables.nix) username state;
in
{
  imports = [
    ./theme
    ./alacritty
    ./fish
    ./waybar
    ./wofi
    ./sway
    ./swaync
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = state;
    packages = with pkgs; [
      # System utils
      xdg-terminal-exec
      pamixer

      # General
      brave
      armcord
      qbittorrent
      obs-studio
      stremio
      vial
      htop
      xfce.thunar
      gdu
      pavucontrol
      hyfetch

      # Programming
      gcc # Some programs such as neovim require the cpp compiler.
      github-cli
      ripgrep
      wget
      git
      tree-sitter

      # Desktop
      wofi
      waybar
      swww
      jq
      grimblast
      wl-clipboard
      whitesur-icon-theme

      # fonts
      jetbrains-mono
      # Disk space is not cheap okay?
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "CascadiaCode"
        ];
      })
    ];
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };

  programs =
    let
      catfy = {
        enable = true;
        catppuccin.enable = true;
      };
    in
    {
      home-manager.enable = true;
      mpv = catfy;
      tmux = catfy;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
