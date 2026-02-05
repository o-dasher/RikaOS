{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.audio;
in
with lib;
{
  options.features.audio.enable = mkEnableOption "audio features";

  config = mkIf modCfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      extraConfig = {
        pipewire-pulse."99-z-defaults"."stream.properties"."resample.quality" = 10;
        client."99-z-defaults"."stream.properties"."resample.quality" = 10;
        pipewire."99-z-defaults"."context.properties" = {
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
            352800
            384000
          ];
        };
      };
    };
  };
}
