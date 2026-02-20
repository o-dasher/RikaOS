{
  lib,
  config,
  ...
}:
with lib;
let
  modCfg = config.features.social;
  cfg = modCfg.email;
  thunderbirdProfile = "thiago-gmail";

  mkMail =
    name:
    args@{
      profile ? thunderbirdProfile,
      ...
    }:
    (recursiveUpdate {
      imap.authentication = mkDefault "plain";
      smtp.authentication = mkDefault "plain";
    } (removeAttrs args [ "profile" ]))
    // optionalAttrs (profile != null) {
      thunderbird = {
        enable = true;
        profiles = [ profile ];
      };
    };

  mkDisrootMail =
    args:
    args
    // {
      imap = {
        host = "disroot.org";
        port = 993;
      };
      smtp = {
        host = "disroot.org";
        port = 587;
        tls.useStartTls = true;
      };
    };

  mkGmail =
    args:
    args
    // {
      flavor = "gmail.com";
      imap.host = "imap.gmail.com";
      smtp.host = "smtp.gmail.com";
    };
in
{
  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) {
    programs.thunderbird = {
      enable = true;
      profiles.${thunderbirdProfile}.isDefault = true;
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = mapAttrs mkMail {
        daishes = mkDisrootMail { };
        thiago-gmail = mkGmail { };
        thiago-disroot = mkDisrootMail { primary = true; };
      };
    };
  };
}
