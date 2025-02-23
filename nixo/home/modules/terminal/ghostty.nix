{
  lib,
  pkgs,
  config,
  ghostty,
  ...
}:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.ghostty.enable) {
    programs.ghostty = {
      enable = true;
      package = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = lib.mkMerge [
        {
          font-size = 14;
          scrollback-limit = 10000;
          clipboard-read = "allow";
          clipboard-paste-protection = false;
        }
        (lib.mkIf (!config.gnome.enable) {
          gtk-titlebar = false;
          window-decoration = false;
        })
      ];
    };
  };
}
