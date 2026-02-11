{ lib, ... }:
with lib;
{
  options.features.filesystem = {
    enable = mkEnableOption "filesystem features" // {
      default = true;
    };
  };
}
