{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.browser;
in
with lib;
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
