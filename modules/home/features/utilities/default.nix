{ lib, ... }:
with lib;
{
  imports = [
    ./nemo.nix
    ./trash.nix
  ];

  options.features.utilities = {
    nemo.enable = mkEnableOption "nemo";
    trash = {
      enable = mkEnableOption "trash alias + cleanup";
      retentionDays = mkOption {
        type = types.int;
        default = 14;
        description = "Delete Trash items older than this many days";
      };
      schedule = mkOption {
        type = types.str;
        default = "daily";
        description = "systemd user timer OnCalendar schedule";
      };
      aliasRm = mkOption {
        type = types.bool;
        default = true;
        description = "Alias rm to trash-put in fish";
      };
    };
    enable = mkEnableOption "utilities" // {
      default = true;
    };
  };
}
