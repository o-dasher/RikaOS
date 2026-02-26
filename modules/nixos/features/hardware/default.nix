{ lib, ... }:
with lib;
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
  ];

  options.features.hardware = {
    enable = mkEnableOption "hardware features" // {
      default = true;
    };
  };
}
