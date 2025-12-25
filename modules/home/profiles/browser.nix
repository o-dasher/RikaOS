{
  lib,
  config,
  ...
}:
{
  options.profiles.browser = {
    enable = lib.mkEnableOption "browser profile";
  };

  config = lib.mkIf config.profiles.browser.enable {
    programs.zen-browser.enable = true;
  };
}
