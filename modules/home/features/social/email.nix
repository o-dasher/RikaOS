{
  lib,
  config,
  ...
}:
let
  cfg = config.features.social.email;
  thunderbirdProfile = "thiago-gmail";
in
{
  options.features.social.email.enable = lib.mkEnableOption "Email accounts.";

  config = lib.mkIf (config.features.social.enable && cfg.enable && config.rika.utils.hasSecrets) {
    programs.thunderbird = {
      enable = true;
      profiles.${thunderbirdProfile}.isDefault = true;
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts.thiago-gmail = {
        primary = true;
        flavor = "gmail.com";
        imap = {
          host = "imap.gmail.com";
          authentication = lib.mkDefault "plain";
        };
        smtp = {
          host = "smtp.gmail.com";
          authentication = lib.mkDefault "plain";
        };
        thunderbird = {
          enable = true;
          profiles = [ thunderbirdProfile ];
        };
      };
    };
  };
}
