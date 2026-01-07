{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.social.discord;

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
{
  options.features.social.discord = {
    enable = lib.mkEnableOption "Discord with Krisp";
    enableKrispPatch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Krisp noise suppression patch for Discord";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services =
      let
        mkTrayService =
          {
            name,
            pkg,
            condition,
          }:
          lib.nameValuePair name (
            lib.mkIf condition {
              Unit = {
                Description = "${name} client";
                After = [ "graphical-session.target" ];
                PartOf = [ "graphical-session.target" ];
              };
              Install.WantedBy = [ "graphical-session.target" ];
              Service = {
                ExecStart = "${lib.getExe pkg} --start-minimized";
                Restart = "on-failure";
              };
            }
          );
      in
      {
        krisp-patcher = lib.mkIf cfg.enableKrispPatch {
          Unit = {
            Description = "Patch Discord Krisp node";
            After = [ "graphical-session-pre.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            Type = "oneshot";
            ExecStart = "${patcherScript}";
          };
        };
      }
      // builtins.listToAttrs [
        (mkTrayService {
          name = "vesktop";
          pkg = pkgs.vesktop;
          condition = config.programs.nixcord.vesktop.enable;
        })
        (mkTrayService {
          name = "discord";
          pkg = pkgs.discord;
          condition = config.programs.nixcord.discord.enable;
        })
      ];

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      config.plugins = {
        fakeNitro.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
