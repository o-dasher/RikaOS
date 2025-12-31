{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = (lib.mkIf config.targets.genericLinux.enable) {
    features.filesystem.sharedFolders.configurationRoot = "~/Programming/RikaOS";

    # https://github.com/nix-community/home-manager/issues/7027
    # Fixes PAM on Ubuntu desktops.
    programs.hyprlock.package = pkgs.hyprlock.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.patchelf ];
      postFixup = ''
        file="$out/bin/hyprlock"
        patchelf --replace-needed libpam.so.0 /usr/lib/x86_64-linux-gnu/libpam.so.0 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libpam_misc.so.0 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libpamc.so.0 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libaudit.so.1 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libcap-ng.so.0 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libcrypt.so.1 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libpwquality.so.1 "$file"
        patchelf --add-needed /usr/lib/x86_64-linux-gnu/libcrack.so.2 "$file"
      '';
    });

    # NixGL configuration
    nixGL.packages = inputs.nixgl.packages;

    programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
    wayland.windowManager.hyprland.package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);
  };
}
