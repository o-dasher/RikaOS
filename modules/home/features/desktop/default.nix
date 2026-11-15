{
  lib,
  osConfig ? null,
  ...
}:
{
  imports = [
    ./umbriel
    ./theme
    ./wayland
  ];

  options.features.desktop.laptop.enable = lib.mkOption {
    type = lib.types.bool;
    default = osConfig != null && osConfig.features.hardware.laptop.enable;
    defaultText = lib.literalExpression "osConfig != null && osConfig.features.hardware.laptop.enable";
    description = "Laptop desktop experience.";
  };

  config.fonts.fontconfig.enable = true;
}
