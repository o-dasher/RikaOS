{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.email;
  thunderbirdProfile = "thiago-gmail";

  mkMail =
    name:
    args@{
      profile ? thunderbirdProfile,
      ...
    }:
    (lib.recursiveUpdate {
      imap.authentication = lib.mkDefault "plain";
      smtp.authentication = lib.mkDefault "plain";
    } (removeAttrs args [ "profile" ]))
    // lib.optionalAttrs (profile != null) {
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
  options.features.social.email.enable = lib.mkEnableOption "Email accounts.";

  config = lib.mkIf (config.features.social.enable && cfg.enable && config.rika.utils.hasSecrets) {
    home.packages = [ pkgs.protonmail-desktop ];
    programs.thunderbird = {
      enable = true;
      profiles.${thunderbirdProfile}.isDefault = true;
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = lib.mapAttrs mkMail {
        thiago-gmail = mkGmail { primary = true; };
      };
    };
  };
}
