{
  # The attribute name (e.g., "hinamizawa") is used as the `targetHostName`.
  # The `hostName` attribute is used for the `nixosConfigurations` output name,
  # and it defaults to the `targetHostName` if not specified.
  systemCfgs = {
    hinamizawa = {
      state = "24.11";
      profiles = {
        rika = "rika";
        satoko = "satoko";
      };
    };
    gensokyo = {
      state = "24.05";
      profiles = {
        nue = "thiago";
      };
    };
    grandline = {
      state = "24.05";
      profiles = {
        zoro = "zoro";
      };
    };
  };

  # Home manager only configurations
  homeCfgs = {
    silly = {
      hostName = "gpmecatronica-System-Product-Name";
      state = "24.05";
      profiles = {
        thiagogpm = "thiagogpm";
      };
    };
  };
}
