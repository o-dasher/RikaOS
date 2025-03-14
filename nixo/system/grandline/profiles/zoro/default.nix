{
  ...
}:
{
  imports = [
    ../../shared.nix
    ./theme
  ];

  nixpkgs.config.allowUnfree = true;
  neovim.enable = true;
  terminal.enable = true;

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    hyfetch = {
      enable = true;
      settings = {
        preset = "bisexual";
        mode = "rgb";
        color_align.mode = "horizontal";
      };
    };
  };
}
