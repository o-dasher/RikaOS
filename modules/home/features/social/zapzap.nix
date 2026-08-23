{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.zapzap;
in
{
  options.features.social.zapzap.enable = lib.mkEnableOption "ZapZap";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = pkgs.zapzap; }) ];

    # Mitigate QtWebEngine / Chromium CPU & memory accumulation over long sessions
    home.sessionVariables.QTWEBENGINE_CHROMIUM_FLAGS = builtins.concatStringsSep " " [
      "--js-flags=--max-old-space-size=2048"
      "--disk-cache-size=${toString (128 * 1024 * 1024)}"
      "--renderer-process-limit=1"
      "--enable-low-end-device-mode"
      "--disable-background-timer-throttling=false"
    ];

    programs.zapzap = {
      enable = true;
      settings = {
        onboarding.initial_setup_completed = true;
        web.scroll_animator = false;
        website.open_page = false;
        storage-whats.notification = false;
        performance = {
          cache_size_max = 100;
          force_software_rendering = false;
          hw_accel = true;
        };
        notification = {
          app = false;
          donation_message = true;
        };
        permissions = {
          "auto_grant/microphone" = true;
          "auto_grant/camera_microphone" = true;
        };
        system = {
          wayland = true;
          menubar = false;
          sidebar = false;
          notificationCounter = false;
          theme = "dark";
        };
      };
    };
  };
}
