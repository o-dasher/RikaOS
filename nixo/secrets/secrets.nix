let
  rika_system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlJb/U8u+FDcHncm5l6rtg11mUrsaQDYsgLgqrXKTSO root@hinamizawa";
  rika_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa";

  gpm_user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFrRfALDfIg8JumMXk4j4LQyEIKwPf5pR225wj1hst0";
in
{
  "playit-secret.age".publicKeys = [
    rika_user
    rika_system
  ];

  "tavily-api-key.age".publicKeys = [
    rika_user
    gpm_user
  ];
}
