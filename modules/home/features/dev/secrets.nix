{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.dev.secrets.enable = lib.mkEnableOption "secrets";

  config = lib.mkIf (config.features.dev.secrets.enable && config.age.secrets ? gemini-api-key) {
    home.sessionVariables = {
      GEMINI_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.gemini-api-key.path})
      '';
    };
  };
}
