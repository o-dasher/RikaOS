{
  lib,
  config,
  pkgs,
  options,
  ...
}:
{
  options.features.desktop.wayland.fuzzel.enable = (lib.mkEnableOption "fuzzel") // {
    default = true;
  };

  config =
    lib.mkIf (config.features.desktop.wayland.enable && config.features.desktop.wayland.fuzzel.enable)
      (
        lib.mkMerge [
          (lib.optionalAttrs (options ? stylix) {
            stylix.targets.fuzzel.fonts.override.sizes.popups = config.stylix.fonts.sizes.popups + 4;
          })
          {
            programs.fuzzel = {
              enable = true;
              settings = {
                main = {
                  terminal = lib.getExe pkgs.xdg-terminal-exec;
                  launch-prefix = "${lib.getExe pkgs.app2unit} --fuzzel-compat --";
                  lines = 10;
                  width = 40;
                  line-height = 32;
                  horizontal-pad = 8;
                };
                border = {
                  width = 1;
                  radius = 8;
                };
              };
            };
          }
        ]
      );
}
