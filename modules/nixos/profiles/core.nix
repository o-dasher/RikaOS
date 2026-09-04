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
  options.profiles.core.enable = lib.mkEnableOption "Core host profile." // {
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
