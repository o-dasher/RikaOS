{
  lib,
  config,
  pkgs,
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
  options.features.social.email.enable = mkEnableOption "declarative email accounts";

  config = mkIf (modCfg.enable && cfg.enable && config.rika.utils.hasSecrets) {
    home.packages = with pkgs; [ protonmail-desktop ];
    programs.thunderbird = {
      enable = true;
      profiles.${thunderbirdProfile}.isDefault = true;
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = mapAttrs mkMail {
        thiago-gmail = mkGmail { primary = true; };
      };
    };
  };
}
