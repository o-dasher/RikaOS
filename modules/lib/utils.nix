{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.rika.utils = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Utility functions for RikaOS configuration.";
  };

  config.rika.utils = {
    configurationRoot = "/shared/.config";

    idleTimers =
      let
        minute = 60;
      in
      {
        lock = 5 * minute;
        dpms = 10 * minute;
        suspend = 30 * minute;
      };

    hasSecrets = builtins.hasAttr "gemini-api-key" config.age.secrets;

    nixAccessTokens = lib.optionalString (config.age.secrets ? nix-access-tokens) ''
      !include ${config.age.secrets.nix-access-tokens.path}
    '';

    mkAutostartApp =
      {
        pkg,
        args ? "",
        delay ? 0,
        command ? "${lib.getExe pkg}${lib.optionalString (args != "") " ${args}"}",
      }:
      let
        delayArg = lib.optionalString (
          delay > 0
        ) "-p \"ExecStartPre=${lib.getExe' pkgs.coreutils "sleep"} ${toString delay}\" ";
        pkgName = lib.getName pkg;
        desktopItem = pkgs.makeDesktopItem {
          name = pkgName;
          desktopName = pkgName;
          exec = "${lib.getExe pkgs.app2unit} ${delayArg}-- ${command}";
          terminal = false;
          type = "Application";
          noDisplay = true;
        };
      in
      "${desktopItem}/share/applications/${pkgName}.desktop";
  };
}
