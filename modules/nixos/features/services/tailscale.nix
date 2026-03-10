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
    loginServer = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Optional custom control server URL, for example a Headscale instance.";
    };
    extraUpFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra flags passed to `tailscale up` when automatic login is configured.";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) (mkMerge [
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.age.secrets.tailscale-auth-key.path;
        extraUpFlags = optional (cfg.loginServer != null) "--login-server=${cfg.loginServer}" ++ cfg.extraUpFlags;
      };
    }
    (mkIf cfg.trust {
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    })
  ]);
}
