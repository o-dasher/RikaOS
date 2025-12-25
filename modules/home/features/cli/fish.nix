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

          getRootFolderSub = sub: "${config.multiUserFiles.sharedFolders.configurationRoot}/${sub}";
          privateRepoFolder = getRootFolderSub "private";
        in
        lib.mkMerge [
          {
            lg = lib.getExe pkgs.lazygit;
            yay = "nix flake update --flake ${privateRepoFolder} && sudo nixos-rebuild switch --flake ${privateRepoFolder}";
          }
          (aliase pkgs.bash { sail = "vendor/bin/sail"; })
          (
            (lib.mkIf (
              config.multiUserFiles.sharedFolders.enable
              && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
            ))
            (
              aliase pkgs.home-manager {
                hm = "switch --flake ${privateRepoFolder}";
              }
            )
          )
        ];
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
