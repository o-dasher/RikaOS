{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils) prefixset;
in
{
  config = lib.mkIf (config.cli.enable && config.cli.fish.enable) {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
        extraConfig = # tmux
          ''
            set-option -g default-shell "${lib.getExe pkgs.fish}"
            bind-key v split-window -h
          '';
      };
      starship = {
        enable = true;
        settings = {
          gcloud.disabled = true;
        };
      };
      fish = {
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
  };
}
