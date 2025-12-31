{
  lib,
  config,
  ...
}:
{
  options.features.audio = {
    enable = lib.mkEnableOption "audio features";
  };

  config = lib.mkIf config.features.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      lowLatency.enable = true;
      wireplumber.enable = true;
    };
  };
}
