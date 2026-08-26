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
    programs =
      let
        commonExtensions = [
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        ];
      in
      {
        librewolf = {
          enable = true;
          settings."privacy.resistFingerprinting.letterboxing" = false;
          policies = {
            SearchEngines = {
              Default = "Google";
              Add = [
                {
                  Name = "Google";
                  URLTemplate = "https://www.google.com/search?q={searchTerms}";
                  Method = "GET";
                  IconURL = "https://www.google.com/favicon.ico";
                  Alias = "@g";
                }
              ];
            };
            ExtensionSettings =
              builtins.mapAttrs
                (_: slug: {
                  installation_mode = "force_installed";
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
                })
                {
                  "uBlock0@raymondhill.net" = "ublock-origin";
                  "addon@darkreader.org" = "darkreader";
                  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
                };
          };
        };
        brave = {
          enable = true;
          package = pkgs.brave-origin;
          extensions = commonExtensions ++ [
            "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
            "ehdehfcjlmekjdolbbmjgokdfeoocccd" # osu! subdivide nations
          ];
        };
        chromium = {
          enable = true;
          package = pkgs.ungoogled-chromium;
          extensions = commonExtensions;
        };
      };
  };
}
