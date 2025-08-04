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
    terminal = {
      enable = true;
      ghostty.enable = true;
    };

    nixpkgs.config = (lib.mkIf (config.development.android.enable)) {
      allowUnfree = true;
      android_sdk.accept_license = true;
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
          # Some monospaced fonts
          jetbrains-mono
          nerd-fonts.fira-mono
          nerd-fonts.jetbrains-mono
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
