{
  lib,
  config,
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
    home.sessionVariablesExtra = ''
      if [ -r "/run/agenix/gemini-api-key" ]; then
        export GEMINI_API_KEY=$(cat "/run/agenix/gemini-api-key")
      fi
    '';
  };
}
