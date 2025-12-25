{
  lib,
  config,
  pkgs,
  utils,
  osConfig ? null,
  ...
}:
let
  inherit (utils) prefixset;
in
{
  options.cli.fish.enable = lib.mkEnableOption "fish";

  config = lib.mkIf config.cli.fish.enable {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          aliase = pkg: kvpairs: prefixset (lib.getExe pkg) kvpairs;

          privateRepoFolder = "${config.multiUserFiles.sharedFolders.configurationRoot}/private";
        in
        lib.mkMerge (
          with pkgs;
          [
            {
              lg = lib.getExe lazygit;
              yay = "${lib.getExe nix} flake update --flake ${privateRepoFolder} && ${lib.getExe nh} os switch";
            }
            (aliase bash { sail = "vendor/bin/sail"; })
            (
              (lib.mkIf (
                config.multiUserFiles.sharedFolders.enable
                && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
              ))
              (
                aliase pkgs.nh {
                  hm = "home switch --flake ${privateRepoFolder}";
                }
              )
            )
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
