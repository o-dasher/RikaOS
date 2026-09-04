{ lib, ... }:
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
    ./laptop.nix
  ];

  options.features.hardware.enable = lib.mkEnableOption "Hardware features." // {
    default = true;
  };
}
