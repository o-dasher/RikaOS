{
  age.secrets.playit-secret.file = ./playit-secret.age;
  age.secrets.homeserverip.file = ./homeserverip.age; # ipv6 prefix
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
