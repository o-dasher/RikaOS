{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.features.services.transmission;
in
{
  options.features.services.transmission.enable =
    lib.mkEnableOption "Transmission BitTorrent client.";

  config = lib.mkIf cfg.enable {
    services.transmission = {
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
      folderNames = [
        "/shared/Media"
        "/shared/Media/Torrent"
        "/shared/Media/Torrent/.incomplete"
      ];
    };
  };
}
