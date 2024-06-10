{
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.rika;
  nixGLIntel = inputs.nixGL.packages.${pkgs.system}.nixGLIntel;
in
{
  imports = [
    ./wezterm
    ./fish
    ./theme
    ./neovim
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "74f9fb98f22581eaca2e3c518a0a3d6198249fb1490ab4a08f33ec47827e85db";
    })
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  # Fix opengl on nox nixos system. Keep an eye on https://github.com/nix-community/home-manager/issues/3968
  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    stateVersion = cfg.state;
    packages = [
      # Programming
      pkgs.devenv
      pkgs.github-cli
      pkgs.wget
      pkgs.git

      # NixGL -- TODO remove from nixos desktop
      nixGLIntel

      # I love my keyboard.
      pkgs.via
      pkgs.vial

      # NixGL

      # fonts
      pkgs.jetbrains-mono
      # Disk space is not cheap okay?
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "CascadiaCode"
        ];
      })
    ];
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
  };

  programs = {
    bash.enable = true;
    home-manager.enable = true;
    lazygit.enable = true;
    tmux = {
      enable = true;
      mouse = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
