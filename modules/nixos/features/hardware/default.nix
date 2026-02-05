{ lib, ... }:
with lib;
{
  imports = [
    ./amdgpu.nix
    ./keyboard.nix
  ];

  options.features.hardware = {
    enable = mkEnableOption "hardware features";
    amdgpu.enable = mkEnableOption "AMDGPU support";
    keyboard.enable = mkEnableOption "keyboard configuration (QMK/Via)";
  };
}
