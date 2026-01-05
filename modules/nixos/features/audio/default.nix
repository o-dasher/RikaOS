{
  lib,
  config,
  ...
}:
{
  options.features.audio.enable = lib.mkEnableOption "audio features";

  config = lib.mkIf config.features.audio.enable {
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
      lowLatency = {
        enable = true;
        rate = 384000;
      };
      extraConfig = {
        pipewire-pulse."99-z-audiophile"."stream.properties"."resample.quality" = 14;
        client."99-z-audiophile"."stream.properties"."resample.quality" = 14;
        pipewire."99-z-audiophile"."context.properties" = {
          "default.clock.rate" = 384000;
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
      wireplumber.extraConfig = {
        "99-z-kinera-celest" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                { "node.name" = "~alsa_output.*USB_Audio.*"; }
              ];
              actions.update-props."audio.format" = "S32LE";
            }
          ];
        };
      };
    };
  };
}
