{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.boot = {
    enable = lib.mkEnableOption "boot features";
    cachy.enable = lib.mkEnableOption "cachy kernel";
  };

  config = lib.mkIf config.features.boot.enable {
    boot = {
      supportedFilesystems.ntfs = true;
      kernelPackages =
        if config.features.boot.cachy.enable then
          pkgs.cachyosKernels.linuxPackages-cachyos-latest
        else
          pkgs.linuxPackages_latest;
    };
  };
}
