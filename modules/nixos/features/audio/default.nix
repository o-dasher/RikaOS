{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.audio;
in
{
  options.features.audio.enable = lib.mkEnableOption "PipeWire audio." // {
    default = true;
  };

  config = lib.mkIf modCfg.enable {
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
        client."99-resample"."stream.properties"."resample.quality" = 10;
        pipewire."99-allowed-rates"."context.properties" = {
          "default.clock.min-quantum" = 16;
          "default.clock.max-quantum" = 2048;
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

      # Eliminate ALSA hardware buffer safety headroom (default ~1024 frames)
      wireplumber.extraConfig."99-alsa-lowlatency-headroom"."monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.*"; } ];
          actions.update-props = {
            "api.alsa.headroom" = 0;
          };
        }
      ];
    };
  };
}
