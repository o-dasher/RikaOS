{ lib, config, ... }:
let
  modCfg = config.features.services;
  cfg = modCfg.openssh;
in
{
  options.features.services.openssh = {
    enable = lib.mkEnableOption "OpenSSH secure shell daemon with hardened key-only authentication";
    keys = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {
        rika = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa";
        termius_s23 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9VIRN6c74eJ76FmffofBrDet+PgNr3le/XgQno+xV6";
      };
      description = "Mapping of named public SSH keys for system and deployment authentication.";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        KbdInteractiveAuthentication = lib.mkDefault false;
      };
    };
  };
}
