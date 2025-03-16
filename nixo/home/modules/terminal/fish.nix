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
  config = lib.mkIf (config.terminal.enable && config.terminal.fish.enable) {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
        extraConfig = # tmux
          ''
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
              aliase pkgs.home-manager { hm = "switch --flake ${config.sharedFolders.configurationRoot}/nixo"; }
            ))
          ];
        interactiveShellInit = # fish
          ''
            ${lib.getExe pkgs.tmux}
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
