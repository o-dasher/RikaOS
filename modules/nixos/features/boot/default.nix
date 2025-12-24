{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.boot = {
    enable = lib.mkEnableOption "boot features";
  };

  config = lib.mkIf config.features.boot.enable {
    boot = {
      # Setup ntfs
      supportedFilesystems.ntfs = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };
  };
}
