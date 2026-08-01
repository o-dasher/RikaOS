{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  modCfg = config.features.editors;
  cfg = modCfg.neovim;
in
{
  options.features.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
    neovide.enable = lib.mkEnableOption "neovide";
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) (
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
