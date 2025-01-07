{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.spotify.enable = lib.mkOption { type = lib.types.bool; };
  config = lib.mkIf (config.spotify.enable) {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        theme = lib.mkForce spicePkgs.themes.text;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          hidePodcasts
        ];
      };
  };
}
