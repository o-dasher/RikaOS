{ lib, ... }:
{
  options.features.filesystem = {
    enable = lib.mkEnableOption "Filesystem features." // {
      default = true;
    };
  };
}
