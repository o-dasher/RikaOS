{
  config,
  lib,
  ...
}:
let
  modCfg = config.features.boot;
  cfg = modCfg.hibernation;
in
{
  options.features.boot.hibernation.enable =
    lib.mkEnableOption "Hibernation support and AM5 hardware freeze workarounds.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    # Reason: Restoring stale ACPI NVS memory clobbers UEFI memory on AM5 during S3 sleep.
    # Fix: Skips restoring NVS memory so clean firmware tables are preserved.
    boot.kernelParams = [ "acpi_sleep=nonvs" ];

    # Reason: AM5 Promontory chipset xHCI (1022:43f7, XH00) loses root hub power / resets during S3
    # (USBSTS 0x411 / 0x401), asserting a spurious PME wakeup that either aborts CPU freeze
    # ("Wakeup pending. Abort CPU freeze") or wakes the machine seconds into suspend-then-hibernate.
    # Keyboard wakeup remains active via the CPU-integrated Raphael xHCI controller (1022:15b8).
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x43f7", ATTR{power/wakeup}="disabled"
    '';

    systemd.sleep.settings.Sleep = {
      # Reason: Default SuspendState falls back from "mem" to "freeze" (s2idle) when an early wake event
      # aborts S3. On AM5 (Raphael iGPU + Navi 22 dGPU), s2idle is unsupported (-EINVAL) and leaves the
      # dGPU SMU and xHCI controller wedged in a self-deadlocking reset loop.
      # Fix: Restrict SuspendState strictly to "mem" (ACPI S3) so aborted sleeps resume cleanly.
      SuspendState = "mem";

      # Reason: ACPI S4 platform mode leaves AM5 xHCI USB controllers in an invalid context state,
      # causing subsequent PCIe bus stalls and hard system freezes after wake.
      # Fix: Use shutdown mode to power off cleanly without entering ACPI S4, ensuring clean cold POST on wake.
      HibernateMode = "shutdown";
    };
  };
}
