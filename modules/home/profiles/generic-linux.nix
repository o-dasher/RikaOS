{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = (lib.mkIf config.targets.genericLinux.enable) {
    features.filesystem.sharedFolders.configurationRoot = "~/Programming/RikaOS";

    # https://github.com/nix-community/home-manager/issues/7027
    # Fixes PAM on generic linux desktops.
    pamShim.enable = true;
    programs.hyprlock.package = config.lib.pamShim.replacePam pkgs.hyprlock;
  };
}
