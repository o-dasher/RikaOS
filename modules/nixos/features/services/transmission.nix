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
    openRPCPort = mkOption {
      type = types.bool;
      default = true;
      description = "Open the firewall for Transmission's RPC port.";
    };
    openPeerPorts = mkOption {
      type = types.bool;
      default = true;
      description = "Open the firewall for Transmission's peer ports.";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      services.transmission = {
        inherit (cfg) openRPCPort openPeerPorts;
        enable = true;
        package = pkgs.transmission_4;
        settings = {
          incomplete-dir-enabled = true;
          download-dir = "/shared/Media/Torrent";
          incomplete-dir = "/shared/Media/Torrent/.incomplete";
        };
      };

      features.filesystem.sharedFolders = {
        enable = true;
        folders.shared.Media.Torrent.".incomplete" = [ ];
      };
    }
  ]);
}
