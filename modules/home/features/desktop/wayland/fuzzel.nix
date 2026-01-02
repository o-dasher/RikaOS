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
                  width = 40;
                  lines = 10;
                  line-height = 24;
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
