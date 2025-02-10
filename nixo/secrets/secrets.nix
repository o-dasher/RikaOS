let
  homeserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk7HNanv/2ETYviP4NcWUh4bHm+hFDKz+DSd6qDRt8O root@thiagoserver";
  home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZYl2IopT2faVx8AMT6N/BHjgj1BZetmTpSEmLc7LSL root@thiagohome";
in
{
  "playit-secret.age".publicKeys = [
    home
    homeserver
  ];
}
