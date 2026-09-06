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
  options.features.boot.hibernation = {
    enable = lib.mkEnableOption "Hibernation support and hardware freeze workarounds.";
    workarounds.enable = lib.mkEnableOption "Workarounds for AM5 ACPI S4 / USB xHCI freeze on resume.";
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) (
    lib.mkMerge [
      (lib.mkIf cfg.workarounds.enable {
        # Reason: Restoring stale ACPI NVS memory clobbers UEFI memory on AM5 during S3 sleep.
        # Fix: Skips restoring NVS memory so clean firmware tables are preserved.
        boot.kernelParams = [ "acpi_sleep=nonvs" ];

        # Reason: ACPI S4 platform mode leaves AM5 xHCI USB controllers in an invalid context state,
        # causing subsequent PCIe bus stalls and hard system freezes after wake.
        # Fix: Use shutdown mode to power off cleanly without entering ACPI S4, ensuring clean cold POST on wake.
        systemd.sleep.settings.Sleep.HibernateMode = "shutdown";
      })
    ]
  );
}
