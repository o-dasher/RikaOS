{
  lib,
  config,
  ...
}:
let
  cfg = config.features.development.secrets;
in
{
  options.features.development.secrets.enable = lib.mkEnableOption "User secrets integration.";

  config = lib.mkIf (cfg.enable && config.rika.utils.hasSecrets) {
    home.sessionVariablesExtra = ''
      if [ -r "/run/agenix/gemini-api-key" ]; then
        export GEMINI_API_KEY=$(cat "/run/agenix/gemini-api-key")
      fi
    '';
  };
}
