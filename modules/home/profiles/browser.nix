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
    programs.brave.enable = true;
  };
}
