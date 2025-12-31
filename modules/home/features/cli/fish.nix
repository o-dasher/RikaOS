{
  lib,
  config,
  pkgs,
  osConfig ? null,
  ...
}:
let
  inherit (config.rika.utils) prefixset;
in
{
  options.cli.fish.enable = lib.mkEnableOption "fish";

  config = lib.mkIf config.cli.fish.enable {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          aliase = pkg: kvpairs: prefixset (lib.getExe pkg) kvpairs;

          publicFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/public";
          privateFlake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";

          updateFlake = flake: "${lib.getExe pkgs.nix} flake update --flake ${flake}";
          mkUpdateUtils =
            suffix: with pkgs; {
              yay = "${updateFlake publicFlake} && ${updateFlake privateFlake} && ${lib.getExe nh} ${suffix}";
              meh = "nix flake update rikaos --flake ${privateFlake} && ${lib.getExe nh} ${suffix}";
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
            {
              lg = lib.getExe lazygit;
            }
          ]
        );
      interactiveShellInit = # fish
        ''
          set -gx EDITOR nvim
          function fish_greeting
            echo Welcome (set_color magenta)home(set_color normal) $USER how are you doing today\?
            echo (set_color magenta; date; set_color normal)
            ${lib.getExe pkgs.jp2a} --height=32 --colors ${../../../../assets/Ascii/rika.jpg}
          end
        '';
    };
  };
}
