{
  lib,
  config,
  nixCaches,
  ...
}:
let
  cfg = config.features.core.nix;
in
{
  options.features.core.nix.enable = lib.mkEnableOption "Nix configuration and tools." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = nixCaches;
      extraOptions = config.rika.utils.nixAccessTokens;
    };
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 4 --keep-since 8d";
      };
      flake = "${config.rika.utils.configurationRoot}/private";
    };
  };
}
