{ lib, ... }:
with lib;
{
  options.features.services.openssh = {
    keys = mkOption {
      type = with types; attrsOf str;
      description = "Repository-managed named OpenSSH public keys for host user authorization.";
      default = {
        rika = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa";
        termius_s23 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9VIRN6c74eJ76FmffofBrDet+PgNr3le/XgQno+xV6";
      };
    };
  };
}
