{ lib, ... }:
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
  ];

  options.features.hardware.enable = lib.mkEnableOption "hardware features" // {
    default = true;
  };
}
