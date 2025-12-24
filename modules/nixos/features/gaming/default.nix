{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.features.gaming = {
    enable = lib.mkEnableOption "gaming features";
  };

  config = lib.mkIf config.features.gaming.enable {
    nixpkgs.config.allowUnfree = true;

    hardware.opentabletdriver.enable = true;
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
    services.lact.enable = true;
    hardware.graphics =
      let
        hypr-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        enable32Bit = true;
        package = hypr-pkgs.mesa;
        package32 = hypr-pkgs.pkgsi686Linux.mesa;
      };
    programs = {
      steam.enable = true;
      steam.remotePlay.openFirewall = true;
      gamemode.enable = true;
      gamescope.enable = true;
      gamescope.capSysNice = false;
    };

    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
