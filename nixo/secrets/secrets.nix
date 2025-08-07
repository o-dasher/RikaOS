let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlJb/U8u+FDcHncm5l6rtg11mUrsaQDYsgLgqrXKTSO root@hinamizawa";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa";
in
{
  "playit-secret.age".publicKeys = [
    user
    system
  ];
}
