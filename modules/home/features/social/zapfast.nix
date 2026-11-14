{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.zapfast;

  # ZapFast (via fastframe-fonts) resolves its Linux UI font by querying fontconfig for `system-ui`.
  zapfastFontconfig = pkgs.writeText "zapfast-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
      <dir>${pkgs.roboto}/share/fonts</dir>
      <match target="pattern">
        <test qual="any" name="family">
          <string>system-ui</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Roboto</string>
        </edit>
      </match>
    </fontconfig>
  '';

  zapfast = pkgs.symlinkJoin {
    name = "zapfast-${pkgs.zapfast.version}";
    paths = [ pkgs.zapfast ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    meta.mainProgram = "zapfast";
    postBuild = ''
      rm "$out/bin/zapfast"
      makeWrapper "${lib.getExe pkgs.zapfast}" "$out/bin/zapfast" \
        --set FONTCONFIG_FILE "${zapfastFontconfig}" \
        --prefix PATH : "${lib.makeBinPath [ pkgs.fontconfig.bin ]}"
    '';
  };
in
{
  options.features.social.zapfast.enable = lib.mkEnableOption "ZapFast WhatsApp client.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [
      zapfast
      pkgs.roboto
    ];
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = zapfast; })
    ];
  };
}
