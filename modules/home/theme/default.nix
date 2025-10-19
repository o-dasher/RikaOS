{ lib, ... }:
{
  options.theme = with lib; {
    cirnold.enable = mkEnableOption "Cirnold theme";
    graduation.enable = mkEnableOption "Graduation theme";
    sakuyadaora.enable = mkEnableOption "Sakuyadaora theme";
  };

  imports = [
    ./cirnold.nix
    ./graduation.nix
    ./sakuyadaora.nix
  ];
}
