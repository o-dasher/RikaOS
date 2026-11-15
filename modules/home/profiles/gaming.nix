{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
let
  cfg = config.profiles.gaming;
  steamPackage = if osConfig != null then osConfig.programs.steam.package else pkgs.steam;
  # Wrap goverlay in FHS environment so it can find vkbasalt
  goverlay-fhs = pkgs.buildFHSEnv {
    name = "goverlay";
    runScript = "goverlay";
    targetPkgs =
      _: with pkgs; [
        goverlay
        vkbasalt
      ];
    extraInstallCommands = ''
      mkdir -p $out/share
      ln -s ${pkgs.goverlay}/share/applications $out/share/applications
      ln -s ${pkgs.goverlay}/share/icons $out/share/icons
    '';
  };
in
{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile.";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      goverlay-fhs
      vulkan-tools
      parsec-bin
    ];

    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp {
        pkg = steamPackage;
        args = "-silent";
      })
    ];

    features.gaming = {
      heroic.enable = true;
      mangohud.enable = true;
    };
  };
}
