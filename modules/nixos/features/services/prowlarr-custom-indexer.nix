{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.prowlarr.customIndexer;

  inherit (config.services.prowlarr) dataDir;
  definitionsDir = "${dataDir}/Definitions/Custom";
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable && config.services.prowlarr.enable) {
    systemd.services.prowlarr-custom-indexer = {
      description = "Install custom Prowlarr indexer definition";
      wantedBy = [ "prowlarr.service" ];
      before = [ "prowlarr.service" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      path = [
        pkgs.coreutils
        pkgs.curl
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        set -euo pipefail
        install -d -m 0755 "${definitionsDir}"
        curl -fsSL "${cfg.url}" -o "${definitionsDir}/${cfg.filename}"
      '';
    };
  };
}
