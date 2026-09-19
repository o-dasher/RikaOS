{ lib, ... }:
{
  imports = [
    ./amdgpu.nix
    ./laptop.nix
  ];

  options.features.hardware.enable = lib.mkEnableOption "Hardware features." // {
    default = true;
  };
}
