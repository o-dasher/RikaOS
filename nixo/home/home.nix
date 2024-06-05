{ inputs, ... }:
let
  inherit (import ../common/config.nix) username state hostname;
in
{
  imports = [
    ./rika
    ./satoko
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  satoko.enable = (hostname == "nixo");

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = state;
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };
}
