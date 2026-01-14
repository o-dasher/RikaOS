{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  features.core.userPreferences.enable = true;
  features = {
    nix = {
      enable = true;
      nixpkgs.enable = true;
    };
    networking = {
      enable = true;
      networkManager.enable = false;
      stableIPv6 = {
        enable = true;
        matchInterface = "enp1s0";
      };
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  security.polkit.enable = true;
  networking.firewall =
    let
      minecraftPorts = [
        60926
        60927
      ];
    in
    {
      allowedTCPPorts = minecraftPorts;
      allowedUDPPorts = minecraftPorts;
    };

  users.users.thiago = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
