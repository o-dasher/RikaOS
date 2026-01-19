{
  lib,
  config,
  ...
}:
{
  options.profiles.social = {
    enable = lib.mkEnableOption "social profile";
  };

  config = lib.mkIf config.profiles.social.enable {
    features.social.discord.enable = true;
    programs.zapzap = {
      enable = true;
      settings = {
        web.scroll_animator = true;
        storage-whats.notification = false;
        notification = {
          app = false;
          donation_message = true;
        };
        system = {
          start_background = true;
          start_system = true;
          wayland = true;
          notificationCounter = true;
        };
      };
    };
  };
}
