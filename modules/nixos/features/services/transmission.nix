{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.transmission;
in
with lib;
{
  options.features.services.transmission = {
    enable = mkEnableOption "Transmission BitTorrent client";
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open the firewall for Transmission's ports.";
    };
    tailnetSetup = mkOption {
      type = types.bool;
      default = true;
      description = "Setup the BitTorrent client for tailscale.";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        settings = mkMerge [
          ((mkIf cfg.tailnetSetup) {
            rpc-username = "admin";
            rpc-bind-address = "0.0.0.0";
          })
          {
            incomplete-dir-enabled = true;
            download-dir = "/shared/Media/Torrent";
            incomplete-dir = "/shared/Media/Torrent/.incomplete";
          }
        ];
        inherit (cfg) openFirewall;
      };

      features.filesystem.sharedFolders = {
        enable = true;
        folders.shared.Media.Torrent.".incomplete" = [ ];
      };
    }
    (mkIf (config.age.secrets ? transmission-credentials) {
      services.transmission.credentialsFile = config.age.secrets.transmission-credentials.path;
    })
  ]);
}
