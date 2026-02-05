{ lib, ... }:
with lib;
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
  ];

  options.features.hardware = {
    amdgpu.enable = mkEnableOption "AMDGPU support";
    keyboard.enable = mkEnableOption "keyboard configuration (QMK/Via)";
    enable = mkEnableOption "hardware features" // {
      default = true;
    };
  };
}
