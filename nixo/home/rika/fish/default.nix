{
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils) prefixset;
in
{
  programs = {
    starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
    fish = {
      enable = true;
      shellAliases =
        {
          # git
          lg = lib.getExe pkgs.lazygit;
          # dev
          sail = "bash vendor/bin/sail";
        }
        // prefixset pkgs.home-manager { hm = "switch --flake ~/.config/nixo"; }
        // prefixset pkgs.tmux {
          tls = "ls";
          tks = "kill-session";
        }
        // prefixset pkgs.git {
          ga = "add";
          gr = "restore";
          gb = "branch";
          gs = "status";
        };

      interactiveShellInit = ''
        function fish_greeting
        	echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
        	echo (set_color magenta; date)
        end
      '';
    };
  };
}
