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
      firefox
      discord
      qbittorrent
      obs-studio
      stremio
      vial
      htop
      hyfetch

      # Programming
      rustup
      github-cli
      ripgrep
      gcc
      wget
      nodejs_22
      git
      tree-sitter

      # Desktop
      wofi
      waybar
      swww
      jq
      grimblast
      wl-clipboard
      xfce.thunar
      pavucontrol
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

      #	My linters	
      eslint_d

      # My formatters
      prettierd
      nixfmt-rfc-style

      # My lsps
      # reference: https://github.com/dundalek/lazy-lsp.nvim/blob/master/servers.md#curated-servers
      nixd
	  lua-language-server
      typescript
      phpactor
      pyright
      nodePackages.vscode-langservers-extracted
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
    };
}
