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
with lib;
{
  options.features.editors.neovim = {
    enable = mkEnableOption "neovim";
    neovide.enable = mkEnableOption "neovide";
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    (mkIf (cfg.neovide.enable) {
      programs.neovide.enable = true;
      home.packages = [ pkgs.source-code-pro ];
    })
    {
      programs.lazygit.enable = true;
      home.packages = [
        (import ../../../../flakes/neovim/package.nix {
          inherit pkgs;
          mnw = inputs.mnw;
        })
      ];
    }
  ]);
}
