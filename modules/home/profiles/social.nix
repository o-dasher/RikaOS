{
  lib,
  config,
  pkgs_master,
  ...
}:
{
  options.profiles.social = {
    enable = lib.mkEnableOption "social profile";
  };

  config = lib.mkIf config.profiles.social.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = true;
      vesktop = {
        enable = true;
        package = pkgs_master.vesktop;
      };
      config.plugins = {
        fakeNitro.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
