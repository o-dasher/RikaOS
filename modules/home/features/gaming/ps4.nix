{
  lib,
  pkgs,
  config,
  ...
}:
let
  sources = pkgs.callPackage ../../../../_sources/generated.nix { };

  ps4-pkg-tools = pkgs.stdenv.mkDerivation {
    inherit (sources.ps4-pkg-tools) pname version src;

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      qt6.qtbase
    ];

    buildPhase = ''
      runHook preBuild
      make
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 ps4-pkg-tool $out/bin/ps4-pkg-tool
      install -Dm755 ps4-pkg-tool-gui $out/bin/ps4-pkg-tool-gui
      runHook postInstall
    '';

    meta = {
      description = "Stand-alone PS4 PKG extraction tool";
      homepage = "https://github.com/xXJSONDeruloXx/ps4-pkg-tools";
      license = lib.licenses.gpl2;
      platforms = lib.platforms.linux;
      mainProgram = "ps4-pkg-tool-gui";
    };
  };
in
{
  options.features.gaming.ps4.enable = lib.mkEnableOption "ps4";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.ps4.enable) {
    services.flatpak.packages = [ "net.shadps4.shadPS4" ];
    home.packages = [ ps4-pkg-tools ];
  };
}
