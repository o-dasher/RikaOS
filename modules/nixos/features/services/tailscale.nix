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
  options.features.services.tailscale = {
    enable = mkEnableOption "tailscale";
    trust = mkEnableOption "Trusts tailscale inteface on the firewall";
  };

  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) (mkMerge [
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.age.secrets.tailscale-auth-key.path;
      };
    }
    (mkIf cfg.trust {
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    })
  ]);
}
