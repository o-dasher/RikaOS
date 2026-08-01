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
    home.packages = with pkgs; [ ungoogled-chromium ];
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
      chromium = {
        enable = true;
        package = pkgs.brave-origin;
        extensions = [
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "ehdehfcjlmekjdolbbmjgokdfeoocccd" # osu! subdivide nations
        ];
      };
    };
  };
}
