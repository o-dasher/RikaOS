{ lib, pkgs, ... }:
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
        let
          aliase = pkg: kvpairs: builtins.mapAttrs (name: value: (lib.getExe pkg) + value) kvpairs;
        in
        {
          # git
          lg = lib.getExe pkgs.lazygit;
          # dev
          sail = "bash vendor/bin/sail";
        }
        // aliase pkgs.home-manager { hm = "switch --flake ~/.config/nixo"; }
        // aliase pkgs.tmux {
          tls = "ls";
          tks = "kill-session";
        }
        // aliase pkgs.git {
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
