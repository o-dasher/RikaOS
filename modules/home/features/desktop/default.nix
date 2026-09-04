{
  lib,
  osConfig ? null,
  ...
}:
{
  imports = [
    ./hyprland
    ./theme
    ./wayland
    ./fonts.nix
  ];

  options.features.desktop = {
    enable = lib.mkEnableOption "Desktop features." // {
      default = true;
    };
    laptop.enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig != null && osConfig.features.hardware.laptop.enable;
      defaultText = lib.literalExpression "osConfig != null && osConfig.features.hardware.laptop.enable";
      description = "Laptop desktop experience.";
    };
  };
}
