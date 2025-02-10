let
  homeserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2oa2zrDNYKJpW4BiIU81yslyQTHT5qvSZfayOBX5A7 daishes@disr.it";
  home = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCoZNIsdsGyQwUiXH1Ft+f5bhcWkHdYmJl2nlQd9lfZ daishes@disr.it";
in
{
  "playit-secret.age".publicKeys = [
    home
    homeserver
  ];
}
