{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.development = with lib; {
    enable = mkEnableOption "development";
    android.enable = mkEnableOption "android";
  };

  config = (lib.mkIf config.development.enable) {
    neovim.enable = true;

    age.secrets.tavily-api-key.file = ../../../secrets/tavily-api-key.age;
    age.secrets.gemini-api-key.file = ../../../secrets/gemini-api-key.age;

    home.sessionVariables = {
      TAVILY_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.tavily-api-key.path})
      '';
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
      source = config.lib.file.mkOutOfStoreSymlink ../../../../../ideavim;
      recursive = true;
    };

    home.packages =
      with pkgs;
      (lib.mkMerge [
        [
          neovide

          # Database management
          jetbrains.datagrip

          # Some monospaced fonts
          jetbrains-mono
          nerd-fonts.fira-mono
          nerd-fonts.jetbrains-mono

          gemini-cli

        ]
        ((lib.mkIf config.development.android.enable) [ android-studio ])
      ]);

    programs = {
      gh.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
