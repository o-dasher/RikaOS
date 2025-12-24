{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.services.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf config.features.services.printing.enable {
    services.printing.enable = true;
  };
}
