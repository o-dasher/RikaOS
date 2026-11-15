{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.features.editors.neovim;
in
{
  options.features.editors.neovim = {
    enable = lib.mkEnableOption "Neovim.";
    neovide.enable = lib.mkEnableOption "Neovide.";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.neovide.enable {
        programs.neovide.enable = true;
        home.packages = [ pkgs.source-code-pro ];
      })
      {
        programs.lazygit.enable = true;
        home.packages = [
          (import ../../../../flakes/neovim/package.nix {
            inherit (inputs) mnw;
            inherit pkgs;
          })
        ];
      }
    ]
  );
}
