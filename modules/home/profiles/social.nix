{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.profiles.social = {
    enable = lib.mkEnableOption "social profile";
  };

  config =
    let
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
    lib.mkIf config.profiles.social.enable {
      systemd.user.services.krisp-patcher = {
        Unit = {
          Description = "Patch Discord Krisp node";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${patcherScript}";
        };
      };

      programs.nixcord = {
        enable = true;
        discord.enable = true;
        vesktop.enable = true;
        config.plugins = {
          fakeNitro.enable = true;
          youtubeAdblock.enable = true;
          webScreenShareFixes.enable = true;
        };
      };
    };
}
