{
  pkgs,
  ...
}:
let
  # Public/VPS interface.
  externalInterface = "eth0";
  wg = {
    interface = "wg0";
    port = 51820;
    # WireGuard private addresses for VPS <-> home tunnel.
    vpsIPv4 = "10.72.0.1";
    homeIPv4 = "10.72.0.2";
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/vda";
  features = {
    boot.kernel.enable = true;
    services.tailscale.enable = true;
    networking = {
      wireguard = {
        enable = true;
        interface = wg.interface;
        address = "${wg.vpsIPv4}/24";
        listenPort = wg.port;
        peer = {
          publicKey = "adsVEuj+sihaXKsoymSbCEC8dkYeecAP96lZPGCQJl4=";
          allowedIPs = [ "${wg.homeIPv4}/32" ];
        };
      };
      nicotineRelay = {
        enable = true;
        tunnelInterface = wg.interface;
        tunnelSourceIPv4 = wg.vpsIPv4;
        tunnelIPv4 = wg.homeIPv4;
        externalPort = 2234;
        inherit externalInterface;
      };
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.lain = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPAM12J0/Z/otlj0f6p6wvrEGFMGiBtcVb9zD7HjRVp rika@hinamizawa"
    ];
  };

  programs.fish.enable = true;
}
