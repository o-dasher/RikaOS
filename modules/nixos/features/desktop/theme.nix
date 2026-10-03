{
  inputs,
  config,
  lib,
  ...
}:
{
  # Rolling Stylix on stable nixpkgs: these targets define options that only exist on nixos-unstable.
  # Their unused modules are dropped entirely, since a target defining a missing option fails evaluation
  # even when disabled.
  disabledModules = map (target: "${inputs.stylix}/modules/${target}/nixos.nix") [
    "kmscon"
    "regreet"
  ];

  config = lib.mkIf config.features.desktop.theme.enable {
    stylix.targets = {
      chromium.enable = true;
      console.enable = true;
      feh.enable = true;
      fish.enable = true;
      font-packages.enable = true;
      fontconfig.enable = true;
      gtk.enable = true;
      gnome.enable = true;
      limine.enable = true;
      qt.enable = true;
    };
  };
}
