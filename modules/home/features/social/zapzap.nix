{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.features.social.zapzap.enable {
    programs.zapzap = {
      enable = true;
      settings = {
        web.scroll_animator = true;
        website.open_page = false;
        storage-whats.notification = false;
        performance.cache_size_max = 100;
        notification = {
          app = false;
          donation_message = true;
        };
        system = {
          start_background = true;
          start_system = true;
          wayland = true;
          menubar = false;
          sidebar = false;
          notificationCounter = true;
        };
      };
    };
  };
}
