{
  lib,
  pkgs,
  pkgs-bleeding,
  config,
  ...
}:
{
  options.development = with lib; {
    enable = mkEnableOption "development";
    android.enable = mkEnableOption "android";
    games.enable = mkEnableOption "games";
  };

  config = (lib.mkIf config.development.enable) {
    neovim.enable = true;

    home.sessionVariables = {
      GEMINI_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.gemini-api-key.path})
      '';
    };

    cli = {
      enable = true;
      hyfetch.enable = true;
    };

    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    nixpkgs.config = {
      allowUnfree = true;
      android_sdk.accept_license = config.development.android.enable;
    };

    xdg.configFile."ideavim" = (lib.mkIf (config.development.android.enable)) {
      source = config.lib.file.mkOutOfStoreSymlink ../../../ideavim;
      recursive = true;
    };

    home.packages = lib.mkMerge [
      (with pkgs; [
        neovide

        # Database management
        jetbrains.datagrip

        # Some monospaced fonts
        jetbrains-mono
        nerd-fonts.fira-mono
        nerd-fonts.jetbrains-mono
      ])

      (with pkgs-bleeding; [
        gemini-cli
      ])

      (lib.mkIf config.development.games.enable (with pkgs; [ godot ]))
      (lib.mkIf config.development.android.enable (with pkgs; [ android-studio ]))
    ];

    programs = {
      gh.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
