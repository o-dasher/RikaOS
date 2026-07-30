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
with lib;
{
  options.features.social.zapzap.enable = mkEnableOption "ZapZap";

  config = mkIf (modCfg.enable && cfg.enable) {
    xdg.configFile = config.rika.utils.mkAutostartApp pkgs.zapzap "zapzap";
    # Mitigate QtWebEngine / Chromium memory accumulation & lag bombing over long sessions
    home.sessionVariables.QTWEBENGINE_CHROMIUM_FLAGS = "--js-flags=--max-old-space-size=1024 --disk-cache-size=52428800 --disable-gpu-memory-buffer-video-frames";
    programs.zapzap = {
      enable = true;
      settings = {
        onboarding.initial_setup_completed = true;
        web.scroll_animator = false;
        website.open_page = false;
        storage-whats.notification = false;
        performance = {
          cache_size_max = 100;
          force_software_rendering = true;
          hw_accel = false;
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
          start_background = true;
          start_system = true;
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
