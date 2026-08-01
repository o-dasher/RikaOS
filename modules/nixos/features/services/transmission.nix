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
{
  options.features.services.transmission = {
    enable = lib.mkEnableOption "Transmission BitTorrent client";
    openRPCPort = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the firewall for Transmission's RPC port.";
    };
    openPeerPorts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the firewall for Transmission's peer ports.";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
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
  };
}
