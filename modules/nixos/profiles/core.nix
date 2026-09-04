{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.core;
in
{
  options.profiles.core.enable =
    lib.mkEnableOption "core host profile (Fish shell, Neovim editor, Limine bootloader, Nix setup, user preferences)"
    // {
      default = true;
    };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.fish;
    features = {
      core.userPreferences.enable = true;
      nix.enable = true;
      boot = {
        enable = true;
        limine.enable = true;
      };
    };
    programs = {
      fish.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };
  };
}
