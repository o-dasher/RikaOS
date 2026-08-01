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
{
  options.features.cli.fish.enable = lib.mkEnableOption "fish";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          aliase = pkg: kvpairs: prefixset (lib.getExe pkg) kvpairs;
          mkUpdateUtils =
            let
              publicFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/public";
              updateFlake = flake: "${lib.getExe pkgs.nix} flake update --flake ${flake}";
            in
            suffix: with pkgs; rec {
              meh = "${lib.getExe nh} ${suffix} --impure";
              yay = "${updateFlake publicFlake} && ${meh}";
            };
        in
        lib.mkMerge (
          with pkgs;
          [
            (aliase bash { sail = "vendor/bin/sail"; })
            (lib.mkIf (osConfig != null) (mkUpdateUtils "os switch"))
            (
              (lib.mkIf (
                config.features.filesystem.sharedFolders.enable
                && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
              ))
              (mkUpdateUtils "home switch")
            )
            ((lib.mkIf config.programs.lazygit.enable) {
              lg = lib.getExe lazygit;
            })
          ]
        );
      interactiveShellInit = # fish
        ''
          function launch-bg --description "Launch a program in the background and disown it"
            $argv > /dev/null 2>&1 &
            disown
          end

          function fish_greeting
            echo Welcome (set_color magenta)home(set_color normal) $USER how are you doing today\?
            echo (set_color magenta; date; set_color normal)
            ${lib.getExe pkgs.jp2a} --height=32 --colors ${../../../../assets/Ascii/rika.jpg}
          end
        '';
    };
  };
}
