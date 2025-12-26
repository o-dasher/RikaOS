{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.secureBoot = with lib; {
    enable = mkEnableOption "secureBoot";
  };

  config = lib.mkIf config.secureBoot.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        secureBoot.enable = true;
        maxGenerations = 3;
      };
    };
  };
}
