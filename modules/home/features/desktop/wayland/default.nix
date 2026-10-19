{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.features.desktop;
  modCfg = desktopCfg.wayland;
in
{
  imports = [
    ./noctalia.nix
  ];

  options.features.desktop.wayland.enable = lib.mkEnableOption "Wayland session integration.";

  config = lib.mkIf (desktopCfg.enable && modCfg.enable) {
    services.udiskie.enable = true;

    home = {
      packages = with pkgs; [
        wl-clipboard
      ];

      sessionVariables = {
        # Ensure OpenSSL-backed apps find CA certs.
        SSL_CERT_DIR = "${pkgs.cacert}/etc/ssl/certs";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        # Electron
        NIXOS_OZONE_WL = "1";

        # SDL
        SDL_VIDEO_DRIVER = "wayland,x11";

        # App2Unit — always use the graphical-session-scoped slices so apps
        # are properly associated with the graphical session regardless of
        # whether UWSM is in use.
        APP2UNIT_TYPE = "service";
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
      };
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
        ];
        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "br";
              DefaultIM = "keyboard-br";
            };
            "Groups/0/Items/0".Name = "keyboard-br";
          };
        };
      };
    };

    # Graphical session slices for app2unit. BindTo graphical-session.target
    # ensures processes in these slices are cleaned up if the session ends.
    systemd.user.slices = {
      "app-graphical".Unit = {
        Description = "User Graphical Application Slice";
        Documentation = "man:systemd.special(7)";
        BindTo = "graphical-session.target";
        After = "graphical-session.target";
      };
      "background-graphical".Unit = {
        Description = "User Graphical Background Application Slice";
        Documentation = "man:systemd.special(7)";
        BindTo = "graphical-session.target";
        After = "graphical-session.target";
      };
      "session-graphical".Unit = {
        Description = "User Graphical Session Application Slice";
        Documentation = "man:systemd.special(7)";
        BindTo = "graphical-session.target";
        After = "graphical-session.target";
      };
    };
  };
}
