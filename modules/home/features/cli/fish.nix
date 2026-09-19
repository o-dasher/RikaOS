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
in
{
  options.features.cli.fish.enable = lib.mkEnableOption "Fish shell.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs.fish = {
      enable = true;
      shellAbbrs =
        let
          switchTarget = if osConfig != null then "os switch" else "home switch";
          root = config.features.filesystem.sharedFolders.configurationRoot;

          nixExe = lib.getExe pkgs.nix;
          update = repo: "${nixExe} flake update --flake ${root}/${repo}";
          switch = "${update "private"} && ${lib.getExe pkgs.nh} ${switchTarget} -v";
        in
        {
          sail = "${lib.getExe pkgs.bash} vendor/bin/sail";
          meh = switch;
          yay = "${update "public"} && ${switch}";
        }
        // lib.optionalAttrs config.programs.lazygit.enable {
          lg = lib.getExe pkgs.lazygit;
        };
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
