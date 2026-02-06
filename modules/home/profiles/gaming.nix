{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.gaming;
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
with lib;
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      goverlay-fhs
      vulkan-tools
      parsec-bin
    ];

    programs.vkbasalt.enable = true;

    features.gaming = {
      steam.enable = true;
      heroic.enable = true;
      mangohud.enable = true;
    };
  };
}
