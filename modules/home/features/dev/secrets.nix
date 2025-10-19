{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dev.secrets.enable = lib.mkEnableOption "secrets" // {
    default = true;
  };

  config = lib.mkIf config.dev.secrets.enable {
    home.sessionVariables = {
      GEMINI_API_KEY = ''
        $(${pkgs.coreutils}/bin/cat ${config.age.secrets.gemini-api-key.path})
      '';
    };
  };
}
