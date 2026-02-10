{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.tailscale;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable && config.age.secrets ? tailscale-auth-key) {
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale-auth-key.path;
      extraUpFlags = [
        "--accept-dns=true"
        "--hostname=${config.networking.hostName}"
      ];
    };
  };
}
