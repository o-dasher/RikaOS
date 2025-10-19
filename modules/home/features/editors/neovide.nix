{ lib, config, pkgs, ... }:
{
  options.editors.neovide.enable = lib.mkEnableOption "neovide";

  config = lib.mkIf config.editors.neovide.enable {
    home.packages = [ pkgs.neovide ];
  };
}
