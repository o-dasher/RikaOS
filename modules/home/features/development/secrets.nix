{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.development;
  cfg = modCfg.secrets;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) {
    home.sessionVariables = {
      GEMINI_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.gemini-api-key.path})
      '';
    };
  };
}
