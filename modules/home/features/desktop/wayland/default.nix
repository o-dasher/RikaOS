{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.wayland;
in
{
  imports = [
    ./walker.nix
    ./wayle.nix
  ];

  options.features.desktop.wayland.enable = lib.mkEnableOption "Wayland base integration";

  config = lib.mkIf (desktopCfg.enable && modCfg.enable) {
    services.udiskie.enable = true;

    home = {
      packages = with pkgs; [ wl-clipboard ];
      sessionVariables = {
        # Ensure OpenSSL-backed apps find CA certs.
        SSL_CERT_DIR = "${pkgs.cacert}/etc/ssl/certs";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        # Electron
        NIXOS_OZONE_WL = "1";

        # SDL
        SDL_VIDEO_DRIVER = "wayland,x11";

        # Fixes ghostty dead keys.
        GTK_IM_MODULE = "simple";

        # App2Unit — always use the graphical-session-scoped slices so apps
        # are properly associated with the graphical session regardless of
        # whether UWSM is in use.
        APP2UNIT_TYPE = "service";
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
      };
    };

    # Graphical session slices for app2unit. BindTo graphical-session.target
    # ensures processes in these slices are cleaned up if the session ends.
    systemd.user.slices = {
      "app-graphical" = {
        Unit = {
          Description = "User Graphical Application Slice";
          Documentation = "man:systemd.special(7)";
          BindTo = "graphical-session.target";
          After = "graphical-session.target";
        };
      };
      "background-graphical" = {
        Unit = {
          Description = "User Graphical Background Application Slice";
          Documentation = "man:systemd.special(7)";
          BindTo = "graphical-session.target";
          After = "graphical-session.target";
        };
      };
      "session-graphical" = {
        Unit = {
          Description = "User Graphical Session Application Slice";
          Documentation = "man:systemd.special(7)";
          BindTo = "graphical-session.target";
          After = "graphical-session.target";
        };
      };
    };
  };
}
