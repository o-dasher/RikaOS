{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.zapzap;
in
{
  options.features.social.zapzap = {
    enable = lib.mkEnableOption "WhatsApp web wrapper.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "zapzap";
        pname = "zapzap";
        meta.mainProgram = "zapzap";
        paths = [
          (pkgs.writeShellScriptBin "zapzap" ''
            userDataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/zapzap"
            lockFile="''${XDG_RUNTIME_DIR:-/tmp}/zapzap.lock"

            # Single-instance enforcement: lock to prevent concurrent or duplicate launches
            exec 9>"$lockFile"
            if ! ${lib.getExe' pkgs.util-linux "flock"} -n 9; then
              if command -v hyprctl >/dev/null 2>&1; then
                hyprctl dispatch "hl.dsp.focus({ workspace = 10 })" >/dev/null 2>&1 || true
              fi
              exit 0
            fi

            # Check if a WhatsApp window already exists in Hyprland
            if command -v hyprctl >/dev/null 2>&1; then
              if hyprctl clients -j 2>/dev/null | grep -q '"class": "brave-web.whatsapp.com__-Default"'; then
                hyprctl dispatch "hl.dsp.focus({ workspace = 10 })" >/dev/null 2>&1 || true
                exit 0
              fi
            fi

            # Clean up stale session restore files and singleton locks so Chromium opens
            # strictly the single window specified by --app and never restores previous
            # sessions after an abnormal shutdown or reboot
            mkdir -p "$userDataDir"
            rm -rf "$userDataDir/Default/Sessions"
            rm -f "$userDataDir/Singleton"*

            exec ${lib.getExe pkgs.brave-origin} \
              --app=https://web.whatsapp.com \
              --user-data-dir="$userDataDir" \
              --disable-session-crashed-bubble \
              --no-first-run \
              --no-default-browser-check \
              "$@"
          '')
          (pkgs.makeDesktopItem {
            name = "zapzap";
            desktopName = "WhatsApp";
            exec = "zapzap %U";
            icon = "whatsapp";
            categories = [
              "Network"
              "InstantMessaging"
              "Chat"
            ];
            terminal = false;
            type = "Application";
          })
        ];
      };
      description = "The WhatsApp package to use.";
    };
  };

  config = lib.mkIf (config.features.social.enable && cfg.enable) {
    home.packages = [ cfg.package ];
  };
}
