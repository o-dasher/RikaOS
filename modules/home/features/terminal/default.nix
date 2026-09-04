{ lib, ... }:
{
  imports = [
    ./ghostty.nix
  ];

  options.features.terminal = {
    enable = lib.mkEnableOption "Terminal features." // {
      default = true;
    };
  };
}
