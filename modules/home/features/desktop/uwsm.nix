{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.uwsm.enable = lib.mkEnableOption "UWSM integration";

  config = lib.mkIf config.desktop.uwsm.enable {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    home.sessionVariables = {
      # app2unit slice configuration
      APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";

      # Wayland stuff
      NIXOS_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # SDL
      OSU_SDL3 = "1";
      SDL_VIDEODRIVER = "wayland";

      # Fixes
      GTK_IM_MODULE = "simple";
    };

    systemd.user.services = {
      vesktop = lib.mkIf (config.programs.nixcord.vesktop.enable or false) {
        Unit = {
          Description = "Vesktop";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.vesktop} --start-minimized";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };

      discord = lib.mkIf (config.programs.nixcord.discord.enable or false) {
        Unit = {
          Description = "Discord";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.discord} --start-minimized";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
