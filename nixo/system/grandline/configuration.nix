# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  lib,
  pkgs,
  cfg,
  inputs,
  ...
}:
let
  inherit (cfg) state;
in
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./shared.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = cfg.profiles.zoro;

  nixSetup = {
    enable = true;
    trusted-users = [ cfg.profiles.zoro ];
  };

  users.users = {
    ${cfg.profiles.zoro} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
      ];
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
    nix-ld.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = state; # Did you read the comment?
}
