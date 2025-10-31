{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dev.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.dev.git.enable {
    home.packages = [
      pkgs.gh
    ];
  };
}
