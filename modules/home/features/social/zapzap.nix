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
            get_whatsapp_address() {
              command -v hyprctl >/dev/null 2>&1 || return 1
              hyprctl clients -j 2>/dev/null | ${lib.getExe pkgs.jq} -r '
                .[] | select((.class // "" | test("brave.*whatsapp"; "i")) or (.initialClass // "" | test("brave.*whatsapp"; "i"))) | .address
              ' 2>/dev/null | head -n 1
            }

            # Determine if we are starting up within the graphical session target
            is_startup=false
            for arg in "$@"; do
              if [ "$arg" = "--silent" ]; then
                is_startup=true
                break
              fi
            done

            if [ "$is_startup" = "false" ] && command -v ${lib.getExe' pkgs.systemd "systemctl"} >/dev/null 2>&1; then
              session_start=$(${lib.getExe' pkgs.coreutils "date"} -d "$(${lib.getExe' pkgs.systemd "systemctl"} --user show -p ActiveEnterTimestamp --value graphical-session.target 2>/dev/null)" +%s 2>/dev/null || echo 0)
              if [ "$session_start" -gt 0 ]; then
                now=$(${lib.getExe' pkgs.coreutils "date"} +%s)
                diff=$((now - session_start))
                if [ "$diff" -ge 0 ] && [ "$diff" -lt 15 ]; then
                  is_startup=true
                fi
              fi
            fi

            # 1. If WhatsApp window already exists:
            addr=$(get_whatsapp_address)
            if [ -n "$addr" ]; then
              if [ "$is_startup" = "false" ]; then
                hyprctl dispatch focuswindow "address:$addr" >/dev/null 2>&1 || true
              fi
              exit 0
            fi

            # 2. If launching during startup, Brave may be restoring its session containing WhatsApp.
            # Poll briefly to avoid opening a duplicate window if Brave restores it.
            if [ "$is_startup" = "true" ] && command -v hyprctl >/dev/null 2>&1; then
              for _ in $(${lib.getExe' pkgs.coreutils "seq"} 1 15); do
                addr=$(get_whatsapp_address)
                if [ -n "$addr" ]; then
                  exit 0
                fi
                ${lib.getExe' pkgs.coreutils "sleep"} 0.1
              done
            fi

            # Filter out internal flags like --silent from arguments
            args=()
            for arg in "$@"; do
              if [ "$arg" != "--silent" ]; then
                args+=("$arg")
              fi
            done

            # Launch WhatsApp in the default Brave browser instance/profile so external links
            # open seamlessly in the user's primary, already-open Brave browser window.
            exec ${lib.getExe pkgs.brave-origin} --app=https://web.whatsapp.com "''${args[@]}"
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
