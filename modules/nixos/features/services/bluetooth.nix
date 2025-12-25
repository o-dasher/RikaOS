{
  lib,
  config,
  ...
}:
{
  options.features.services.bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
  };

  config = lib.mkIf config.features.services.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
