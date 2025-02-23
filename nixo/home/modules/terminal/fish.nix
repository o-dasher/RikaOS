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
      zellij.enable = true;
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

        interactiveShellInit = ''
          function fish_greeting
          	echo Welcome(set_color magenta) home(set_color normal) $USER how are you doing today\?
          	echo (set_color magenta; date)
          end
        '';
      };
    };
  };
}
