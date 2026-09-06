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
    workarounds.enable = lib.mkEnableOption "Kernel parameters to prevent ACPI NVS corruption on resume.";
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    boot.kernelParams = lib.optionals cfg.workarounds.enable [
      # Reason: Restoring stale ACPI NVS memory clobbers UEFI memory on AM5, causing
      # AML buffer limit errors, aborted _WAK/_PS3 methods, and corrupted USB xHCI context.
      # Fix: Skips restoring NVS memory so clean firmware tables are preserved.
      "acpi_sleep=nonvs"
    ];
  };
}
