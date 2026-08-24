{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.zapzap;

  chromiumFlags = builtins.concatStringsSep " " [
    "--js-flags=--max-old-space-size=2048"
    "--disk-cache-size=${toString (128 * 1024 * 1024)}"
    "--renderer-process-limit=1"
    "--enable-features=IntensiveWakeUpThrottling:grace_period_seconds/10"
  ];

  zapzap-pkg = pkgs.symlinkJoin {
    name = "zapzap";
    paths = [
      (pkgs.writeShellScriptBin "zapzap" ''
        export QTWEBENGINE_CHROMIUM_FLAGS="''${QTWEBENGINE_CHROMIUM_FLAGS:-} ${chromiumFlags}"
        exec ${lib.getExe' pkgs.coreutils "nice"} -n 19 ${lib.getExe' pkgs.util-linux "ionice"} -c 3 ${lib.getExe' pkgs.zapzap "zapzap"} "$@"
      '')
      pkgs.zapzap
    ];
  };
in
{
  options.features.social.zapzap.enable = lib.mkEnableOption "ZapZap";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = zapzap-pkg; }) ];

    programs.zapzap = {
      enable = true;
      package = zapzap-pkg;
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
