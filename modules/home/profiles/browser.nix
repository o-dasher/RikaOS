{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.browser;
in
with lib;
{
  options.profiles.browser.enable = mkEnableOption "browser profile";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ungoogled-chromium ];
    programs = {
      floorp = {
        enable = true;
        profiles.default = {
          id = 0;
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            bitwarden
          ];
        };
      };
      chromium = {
        enable = true;
        package = pkgs.brave;
        extensions = [
          "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "ehdehfcjlmekjdolbbmjgokdfeoocccd" # osu! subdivide nations
        ];
      };
    };
  };
}
