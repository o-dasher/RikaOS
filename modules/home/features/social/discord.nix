{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.discord;

  krisp-patcher = pkgs.fetchurl {
    url = "https://github.com/keysmashes/sys/raw/25f9bc04e6b8d59c1abb32bf4e7ce8ed8de048e2/hm/discord/krisp-patcher.py";
    hash = "sha256-h8Jjd9ZQBjtO3xbnYuxUsDctGEMFUB5hzR/QOQ71j/E=";
  };

  pythonWithPackages = pkgs.python3.withPackages (
    p: with p; [
      capstone
      pyelftools
    ]
  );

  patcherScript = pkgs.writeShellScript "krisp-patcher-wrapper" ''
    ${pkgs.fd}/bin/fd '^discord_krisp.node$' "$HOME/.config/discord" \
      --exec ${pythonWithPackages}/bin/python ${krisp-patcher}
  '';
in
with lib;
{
  options.features.social.discord = {
    enable = mkEnableOption "Discord with Krisp";
    enableKrispPatch = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Krisp noise suppression patch for Discord";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) {
    systemd.user.services.krisp-patcher = mkIf cfg.enableKrispPatch {
      Unit = {
        Description = "Patch Discord Krisp node";
        After = [ "graphical-session-pre.target" ];
        Before = [ "xdg-desktop-autostart.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "oneshot";
        ExecStart = "${patcherScript}";
      };
    };

    xdg.configFile = mkIf config.programs.nixcord.vesktop.enable (
      config.rika.utils.mkAutostartApp pkgs.vesktop "${getExe pkgs.vesktop} --start-minimized"
    );

    programs.nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      openASAR.enable = true;
      config.plugins = {
        fakeNitro.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
