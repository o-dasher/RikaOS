{ lib, ... }:
with lib;
{
  options.features.services.openssh = {
    keys = mkOption {
      type = with types; attrsOf str;
      description = "Repository-managed named OpenSSH public keys for host user authorization.";
      default = {
        rika = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa";
      };
    };
  };
}
