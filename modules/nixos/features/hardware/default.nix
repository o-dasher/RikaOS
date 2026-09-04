{ lib, ... }:
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
    ./laptop.nix
  ];

  options.features.hardware.enable =
    lib.mkEnableOption "hardware-specific optimizations, GPU drivers, and device support"
    // {
      default = true;
    };
}
