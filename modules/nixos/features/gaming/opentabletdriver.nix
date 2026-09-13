{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.otd;
in
{
  options.features.gaming.otd = {
    enable = lib.mkEnableOption "OpenTabletDriver." // {
      default = true;
    };
    firmwareFlashing.enable =
      lib.mkEnableOption "udev rules for Wacom and LC87 firmware flashing (https://xstarry.dev/firmware)."
      // {
        default = true;
      };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    hardware = {
      uinput.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    services.udev.extraRules = lib.mkIf cfg.firmwareFlashing.enable ''
      # Wacom firmware flashing (WebHID) and SANYO LC87 bootloader (WebUSB) (https://xstarry.dev/firmware)
      KERNEL=="hidraw*", ATTRS{idVendor}=="056a", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0531", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0ac3", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0ac3", TAG+="uaccess"
    '';
  };
}
