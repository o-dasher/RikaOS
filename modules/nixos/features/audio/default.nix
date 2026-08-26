{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.audio;
  quantum = 32;
  rate = 48000;
  qr = "${toString quantum}/${toString rate}";
in
{
  options.features.audio.enable = lib.mkEnableOption "audio features" // {
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
        pipewire."99-latency-and-rates"."context.properties" = {
          "default.clock.quantum" = quantum;
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

        pipewire-pulse."99-pulse-latency" = {
          "pulse.properties" = {
            "pulse.min.req" = qr;
            "pulse.min.quantum" = qr;
            "pulse.min.frag" = qr;
          };
          "pulse.rules" = [
            {
              matches = [
                { "application.process.binary" = "osu!"; }
                { "application.process.binary" = "cs2"; }
                { "application.process.binary" = "gamescope"; }
              ];
              actions.update-props = {
                "resample.disable" = true;
                "pulse.min.req" = qr;
                "pulse.min.quantum" = qr;
              };
            }
          ];
        };

        client."99-client-latency" = {
          "stream.properties" = {
            "node.latency" = qr;
            "resample.quality" = 10;
          };
          "stream.rules" = [
            {
              matches = [
                { "application.process.binary" = "osu!"; }
                { "application.process.binary" = "cs2"; }
                { "application.process.binary" = "gamescope"; }
              ];
              actions.update-props = {
                "resample.disable" = true;
                "node.latency" = qr;
                "stream.dont-remix" = true;
              };
            }
          ];
        };
      };

      # Eliminate ALSA hardware buffer safety headroom (default ~1024 frames)
      wireplumber.extraConfig."99-alsa-lowlatency-headroom"."monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_output.*"; } ];
          actions.update-props = {
            "api.alsa.period-size" = quantum;
            "api.alsa.headroom" = 0;
          };
        }
      ];
    };
  };
}
