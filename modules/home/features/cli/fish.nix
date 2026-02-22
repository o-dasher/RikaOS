{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.cli;
  cfg = modCfg.fish;
  inherit (config.rika.utils) prefixset;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          aliase = pkg: kvpairs: prefixset (getExe pkg) kvpairs;

          publicFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/public";
          privateFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";

          updateFlake = flake: "${getExe pkgs.nix} flake update --flake ${flake}";
          mkUpdateUtils = switchCmd: {
            yay = "${updateFlake publicFlake} && ${updateFlake privateFlake} && ${switchCmd}";
            meh = "${updateFlake privateFlake} && ${switchCmd}";
          };
        in
        mkMerge (
          with pkgs;
          [
            (aliase bash { sail = "vendor/bin/sail"; })
            (mkIf (osConfig != null) (
              mkUpdateUtils "${getExe pkgs.colmena} apply --on ${osConfig.networking.hostName} -f ${privateFlake}/flake.nix"
            ))
            (
              (mkIf (
                config.features.filesystem.sharedFolders.enable
                && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
              ))
              (mkUpdateUtils "${getExe pkgs.nh} home switch")
            )
            ((mkIf config.programs.lazygit.enable) {
              lg = getExe lazygit;
            })
          ]
        );
      interactiveShellInit = # fish
        ''
          function fish_greeting
            echo Welcome (set_color magenta)home(set_color normal) $USER how are you doing today\?
            echo (set_color magenta; date; set_color normal)
            ${getExe pkgs.jp2a} --height=32 --colors ${../../../../assets/Ascii/rika.jpg}
          end
        '';
    };
  };
}
