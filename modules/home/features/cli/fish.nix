{
  lib,
  config,
  pkgs,
  utils,
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
        in
        lib.mkMerge [
          {
            # git
            lg = lib.getExe pkgs.lazygit;
          }
          (aliase pkgs.bash { sail = "vendor/bin/sail"; })
          ((lib.mkIf config.sharedFolders.enable) (
            aliase pkgs.home-manager { hm = "switch --flake ${config.sharedFolders.configurationRoot}"; }
          ))
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
