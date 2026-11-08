{
  config,
  lib,
  ...
}:
let
  cfg = config.features.desktop.umbriel;
in
{
  options.features.desktop.umbriel.enable = lib.mkEnableOption "Umbriel compositor.";

  config = lib.mkIf cfg.enable {
    programs.umbriel.enable = true;
  };
}
