{ lib, ... }:
{
  options.features.filesystem = {
    enable = lib.mkEnableOption "user-level filesystem integrations and shared folder permissions" // {
      default = true;
    };
  };
}
