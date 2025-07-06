{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.ghostty.enable) {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = lib.mkAfter {
        font-size = 12;
        scrollback-limit = 10000;
        clipboard-read = "allow";
        clipboard-paste-protection = false;
      };
    };
  };
}
