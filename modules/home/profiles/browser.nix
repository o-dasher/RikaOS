{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  modCfg = config.profiles.browser;
in
with lib;
{
  config = mkIf modCfg.enable {
    programs.zen-browser = {
      enable = true;
      package = pkgs.zen-browser;
      policies = {
        AutofillAddressEnabled = true;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.default.extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          bitwarden
        ];
    };
  };
}
