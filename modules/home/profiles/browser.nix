{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.browser;
in
{
  options.profiles.browser.enable = lib.mkEnableOption "browser profile";

  config = lib.mkIf cfg.enable {
    programs = {
      floorp = {
        enable = true;
        profiles.default = {
          id = 0;
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            darkreader
            bitwarden
          ];
        };
      };
      brave = {
        enable = true;
        package = pkgs.brave-origin;
        extensions = [
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "ehdehfcjlmekjdolbbmjgokdfeoocccd" # osu! subdivide nations
        ];
      };
      chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
  };
}
