{
  lib,
  config,
  ...
}:
{
  options.features.audio.enable = lib.mkEnableOption "audio features";

  config = lib.mkIf config.features.audio.enable {
    security.rtkit.enable = true;
    services.pipewire =
      let
      in
      {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
        lowLatency.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        extraConfig = {
          pipewire-pulse."99-z-defaults"."stream.properties"."resample.quality" = 14;
          client."99-z-defaults"."stream.properties"."resample.quality" = 14;
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
