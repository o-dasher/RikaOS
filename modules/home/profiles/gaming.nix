{
  lib,
  config,
  pkgs,
  ...
}:
let
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
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming profile";

  config = lib.mkIf config.profiles.gaming.enable {
    home.packages = with pkgs; [
      goverlay-fhs
      vkbasalt
      vulkan-tools
      parsec-bin
    ];

    features.gaming = {
      enable = true;
      steam.enable = true;
      heroic.enable = true;
      mangohud.enable = true;
    };
  };
}
