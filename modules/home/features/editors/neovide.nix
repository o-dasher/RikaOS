{
  lib,
  config,
  ...
}:
{
  options.editors.neovide.enable = lib.mkEnableOption "neovide";

  config = lib.mkIf config.editors.neovide.enable {
    programs.neovide.enable = true;
  };
}
