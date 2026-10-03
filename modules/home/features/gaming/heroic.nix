{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.heroic;
  extraProtons = {
    "GE-Proton" = pkgs.proton-ge-bin.steamcompattool;
  };
in
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "Heroic Games Launcher.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.heroic ];
    # Heroic owns config.json, so patch the key in place to silence "outdated" notifications.
    home.activation.heroicDisableUpdateCheck = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cfgFile="${config.xdg.configHome}/heroic/config.json"
      if [ -f "$cfgFile" ]; then
        tmp=$(mktemp)
        ${lib.getExe pkgs.jq} '.defaultSettings.checkForUpdatesOnStartup = false' "$cfgFile" > "$tmp" \
          && run mv "$tmp" "$cfgFile"
      fi
    '';
    xdg = {
      autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = pkgs.heroic; }) ];
      configFile = lib.mapAttrs' (
        name: pkg:
        lib.nameValuePair "heroic/tools/proton/${name}" {
          source = pkg;
        }
      ) extraProtons;
    };
  };
}
