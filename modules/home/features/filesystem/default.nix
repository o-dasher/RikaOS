{ lib, ... }:
{
  options.features.filesystem = {
    enable = lib.mkEnableOption "filesystem features" // {
      default = true;
    };
  };
}
