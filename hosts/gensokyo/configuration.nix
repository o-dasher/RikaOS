{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/749d870c-a88c-4c37-82ea-a9807c24cfea";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
    ];
  };

  time.hardwareClockInLocalTime = true;
  profiles.desktop = {
    enable = true;
    virtualization.enable = true;
  };

  features = {
    desktop.theme.cirnosunset.enable = true;
    boot.kernel.enable = true;
    hardware.laptop.enable = true;
    networking = {
      enable = true;
      cloudflare.dns.enable = true;
      privacyIPv6.enable = true;
      primaryInterface = "enp1s0";
    };
    services = {
      openssh.enable = true;
      bluetooth.enable = true;
      gnome-keyring.enable = true;
      sddm.enable = true;
    };
  };

  users.users.thiago = {
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys =
      let
        inherit (config.features.services.openssh.keys) rika termius_s23;
      in
      [
        rika
        termius_s23
      ];
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "render"
      "pipewire"
    ];
  };

  fonts.enableDefaultPackages = true;
  programs = {
    dconf.enable = true;
    nix-ld.enable = true;
    hyprland.enable = true;
  };

  services = {
    tailscale.enable = true;
    tlp.enable = true;
  };
}
