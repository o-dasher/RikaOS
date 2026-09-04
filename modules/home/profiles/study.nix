{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.study;
in
{
  options.profiles.study.enable = lib.mkEnableOption "document and reading profile (Zathura PDF reader and Foliate eBook viewer)";

  config = lib.mkIf cfg.enable {
    programs = {
      # Documents / PDF
      zathura.enable = true;

      # eBooks
      foliate = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "foliate-x11";
          paths = [
            (pkgs.writeShellScriptBin "foliate" ''
              export GDK_BACKEND=x11
              exec ${pkgs.foliate}/bin/foliate "$@"
            '')
            pkgs.foliate
          ];
        };
      };
    };
  };
}
