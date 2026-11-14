{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.multimedia;
in
{
  options.profiles.multimedia.enable = lib.mkEnableOption "Multimedia profile.";

  config = lib.mkIf cfg.enable (
    let
      melba-pkg = inputs.melba.packages.${pkgs.stdenv.hostPlatform.system}.melba-paired;
    in
    {
      services.easyeffects.enable = true;
      profiles.study.enable = lib.mkDefault true;

      systemd.user.services.easyeffects.Unit = {
        After = [ "pipewire.service" ];
        Wants = [ "pipewire.service" ];
        PartOf = [ "pipewire.service" ];
      };

      programs = {
        # Video
        mpv.enable = true;
        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [ obs-vaapi ];
        };
      };

      home.packages = with pkgs; [
        # Downloading
        transmission-remote-gtk

        # Video
        kdePackages.kdenlive

        # Drawing
        krita

        # Music
        melba-pkg
      ];

      xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = melba-pkg; }) ];

      # Stage real files (melbad rejects symlinks via O_NOFOLLOW) while preserving runtime data/auth state.
      home.activation = {
        melbaWrapper =
          let
            melba-wrapper =
              let
                wrapperZip = pkgs.fetchzip {
                  url = "https://github.com/WorldObservationLog/wrapper/releases/download/wrapper.x86_64.latest/Wrapper.x86_64.latest.zip";
                  stripRoot = false;
                  hash = "sha256-rKOOKG6x0j3srOij4KLqqN7rbL9R+ciH1Sc9DHEWHXk=";
                };
                tzdata = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/WorldObservationLog/wrapper/2fd7e0eaef081f93cf687428b965674937832ba4/rootfs/system/usr/share/zoneinfo/tzdata";
                  sha256 = "28d0689618cfb2796a52ba335ab9e535ba68948ad3ecd1a5670e24f762ff2117";
                };
                runScript = pkgs.writeShellScript "run" ''
                  D="$(cd "$(dirname "$0")" && pwd)"
                  exec "$D/wrapper" -H 127.0.0.1 -B "$D/rootfs/data/data/com.apple.android.music/files" "$@"
                '';
              in
              pkgs.runCommand "melba-wrapper" { nativeBuildInputs = [ pkgs.patchelf ]; } ''
                mkdir -p "$out/rootfs/system/usr/share/zoneinfo" "$out/rootfs/data/data/com.apple.android.music/files"
                install -m755 "${wrapperZip}/wrapper" "$out/wrapper"
                install -m755 "${runScript}" "$out/run"
                cp -a "${wrapperZip}/rootfs/system/." "$out/rootfs/system/"
                chmod -R u+w "$out/rootfs/system"
                chmod 755 "$out/rootfs/system/bin/main" "$out/rootfs/system/bin/linker64"
                install -Dm644 "${tzdata}" "$out/rootfs/system/usr/share/zoneinfo/tzdata"

                # Patch only the host glibc launcher; keep bionic rootfs untouched so melbad ABI hashes match.
                patchelf \
                  --set-interpreter "${pkgs.stdenv.cc.bintools.dynamicLinker}" \
                  --set-rpath "${pkgs.glibc.out}/lib" \
                  "$out/wrapper"
              '';
          in
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            wrapperDir="${config.xdg.dataHome}/melba/wrapper"
            stampFile="$wrapperDir/.nix-wrapper-drv"
            if [ "$(cat "$stampFile" 2>/dev/null || true)" != "${melba-wrapper}" ] \
              || [ ! -x "$wrapperDir/run" ] \
              || [ ! -f "$wrapperDir/rootfs/system/bin/main" ]; then
              run mkdir -p -m 0700 "$wrapperDir"
              run chmod 0700 "$wrapperDir"
              run mkdir -p "$wrapperDir/rootfs/system" "$wrapperDir/rootfs/data/data/com.apple.android.music/files"
              run install -m 0755 "${melba-wrapper}/wrapper" "$wrapperDir/wrapper"
              run install -m 0755 "${melba-wrapper}/run" "$wrapperDir/run"
              run cp -rf --remove-destination --no-preserve=ownership "${melba-wrapper}/rootfs/system/." "$wrapperDir/rootfs/system/"
              run chmod -R u+rwX "$wrapperDir/rootfs/system"
              run chmod 0700 "$wrapperDir/rootfs/system/lib64"
              run sh -c 'printf "%s\n" "$1" > "$2"' _ "${melba-wrapper}" "$stampFile"
            fi
          '';

        melbaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          cfgDir="${config.xdg.configHome}/melba"
          cfgFile="$cfgDir/config.json"
          run mkdir -p -m 0700 "$cfgDir"
          tmp=$(mktemp)
          if [ -f "$cfgFile" ]; then
            ${lib.getExe pkgs.jq} '.wrapper_mode = "managed"' "$cfgFile" > "$tmp"
          else
            printf '{\n  "wrapper_mode": "managed"\n}\n' > "$tmp"
          fi
          run install -m 0600 "$tmp" "$cfgFile"
          rm -f "$tmp"
        '';
      };
    }
  );
}
