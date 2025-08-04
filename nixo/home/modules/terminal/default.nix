{ lib, ... }:
{
  imports = [
    ./ghostty.nix
  ];

  options.terminal = with lib; {
    enable = mkEnableOption "terminal";
    ghostty.enable = (mkEnableOption "ghostty");
  };
}
