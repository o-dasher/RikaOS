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
  options.features.development.secrets.enable = mkEnableOption "secrets";

  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) {
    home.sessionVariables = {
      GEMINI_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.gemini-api-key.path})
      '';
    };
  };
}
