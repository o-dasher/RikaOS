{ lib, ... }:
{
  imports = [
    ./fish.nix
    ./ghostty.nix
  ];

  options.terminal = with lib; {
    enable = mkEnableOption "terminal";
    fish.enable = (mkEnableOption "fish") // {
      default = true;
    };
    ghostty.enable = (mkEnableOption "ghostty") // {
      default = true;
    };
  };
}
