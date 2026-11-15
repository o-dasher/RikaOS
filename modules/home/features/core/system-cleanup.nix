{
  lib,
  config,
  ...
}:
let
  cfg = config.features.core.systemCleanup;
in
{
  options.features.core.systemCleanup.enable = lib.mkEnableOption "Automatic user cache cleanup." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    systemd.user.tmpfiles.rules = [
      # Recursively clean stale files in ~/.cache older than 16 days
      "e %h/.cache - - - 16d -"
    ];
  };
}
