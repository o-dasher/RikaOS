{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./system-cleanup.nix
    ./xdg.nix
  ];

  options.features.core = {
    enable =
      lib.mkEnableOption "core user configuration (Nix tools, system cleanup, and XDG directories)"
      // {
        default = true;
      };
  };
}
