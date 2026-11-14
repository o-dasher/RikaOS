{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.zapfast;
in
{
  options.features.social.zapfast.enable = lib.mkEnableOption "ZapFast WhatsApp client.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.zapfast ];
  };
}
