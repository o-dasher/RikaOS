{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.multimedia;
  melba-pkg = inputs.melba.packages.${pkgs.stdenv.hostPlatform.system}.melba-paired;

  wrapperSources = {
    x86_64-linux = {
      arch = "x86_64";
      sha256 = "4bf5ec7869c57baeab13832d14b5c8d1c1167a6dd492a837f1d9b8fb42c2d67a";
    };
    aarch64-linux = {
      arch = "arm64";
      sha256 = "8de5da67e375038ff5a08761c71ccaf90ac5ec711a6d0924ba7328b5e116e0a6";
    };
  };
  wrapperSrcInfo = wrapperSources.${pkgs.stdenv.hostPlatform.system};
  melba-wrapper-zip = pkgs.fetchurl {
    url = "https://github.com/WorldObservationLog/wrapper/releases/download/wrapper.${wrapperSrcInfo.arch}.latest/Wrapper.${wrapperSrcInfo.arch}.latest.zip";
    inherit (wrapperSrcInfo) sha256;
  };
  melba-wrapper-tzdata = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/WorldObservationLog/wrapper/2fd7e0eaef081f93cf687428b965674937832ba4/rootfs/system/usr/share/zoneinfo/tzdata";
    sha256 = "28d0689618cfb2796a52ba335ab9e535ba68948ad3ecd1a5670e24f762ff2117";
  };

  melba-wrapper = pkgs.stdenv.mkDerivation {
    pname = "melba-wrapper";
    version = "unstable-2026-10-19";
    src = melba-wrapper-zip;

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = true;

    nativeBuildInputs = with pkgs; [
      unzip
      patchelf
    ];

    installPhase = ''
      mkdir -p work
      unzip -q "$src" -d work
      nested=$(find work -mindepth 2 -maxdepth 2 -name wrapper -type f | head -n 1 || true)
      if [ -n "$nested" ] && [ ! -e work/wrapper ]; then
        base=$(dirname "$nested")
        mv "$base"/* work/
      fi

      mkdir -p "$out/rootfs/system/usr/share/zoneinfo" "$out/rootfs/data/data/com.apple.android.music/files"
      cp -a work/wrapper "$out/wrapper"
      cp -a work/rootfs/system/. "$out/rootfs/system/"
      install -Dm644 "${melba-wrapper-tzdata}" "$out/rootfs/system/usr/share/zoneinfo/tzdata"

      # Patch only the host glibc launcher; keep bionic rootfs untouched so melbad ABI hashes match.
      chmod 755 "$out/wrapper" "$out/rootfs/system/bin/main" "$out/rootfs/system/bin/linker64"
      patchelf \
        --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" \
        --set-rpath "${pkgs.glibc.out}/lib" \
        "$out/wrapper"

      printf '%s\n' \
        '#!${pkgs.runtimeShell}' \
        'D="$(cd "$(dirname "$0")" && pwd)"' \
        'exec "$D/wrapper" -H 127.0.0.1 \' \
        '    -B "$D/rootfs/data/data/com.apple.android.music/files" "$@"' \
        > "$out/run"
      chmod 755 "$out/run"
    '';
  };
in
{
  options.profiles.multimedia.enable = lib.mkEnableOption "Multimedia profile.";

  config = lib.mkIf cfg.enable {
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
      melbaWrapper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
  };
}
