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
  options.features.cli.fish.enable = mkEnableOption "fish";

  config = mkIf (modCfg.enable && cfg.enable) {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          aliase = pkg: kvpairs: prefixset (getExe pkg) kvpairs;
          mkUpdateUtils =
            let
              publicFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/public";
              updateFlake = flake: "${getExe pkgs.nix} flake update --flake ${flake}";
            in
            suffix: with pkgs; rec {
              meh = "${getExe nh} ${suffix} --impure";
              yay = "${updateFlake publicFlake} && ${meh}";
            };
        in
        mkMerge (
          with pkgs;
          [
            (aliase bash { sail = "vendor/bin/sail"; })
            (mkIf (osConfig != null) (mkUpdateUtils "os switch"))
            (
              (mkIf (
                config.features.filesystem.sharedFolders.enable
                && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
              ))
              (mkUpdateUtils "home switch")
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
