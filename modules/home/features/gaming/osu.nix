{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.osu;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    home = {
      sessionVariables.OSU_SDL3 = 1;
      packages = with inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}; [
        osu-lazer-bin
        (config.features.gaming.gamescope.wrapDefault (
          osu-stable.override {
            # Ensure .osz/.osk/.osr imports live on C: to avoid cross-drive move failures.
            preCommands = ''
              if [ "$#" -gt 0 ]; then
                new_args=()
                for arg in "$@"; do
                  case "$arg" in
                    file://*)
                      arg="''${arg#file://}"
                      arg="''${arg#localhost}"
                      # URL-decode %xx sequences for paths from %U handlers.
                      arg="$(printf '%b' "''${arg//%/\\x}")"
                      ;;
                  esac

                  case "$arg" in
                    *.osz|*.osk|*.osr)
                      if [ -f "$arg" ]; then
                        import_dir="$WINEPREFIX/drive_c/osu/import"
                        mkdir -p "$import_dir"
                        base="$(basename "$arg")"
                        dest="$import_dir/$base"
                        cp -f "$arg" "$dest"
                        rel="''${dest#$WINEPREFIX/drive_c}"
                        rel_win="$(printf '%s' "$rel" | sed 's,/,\\\\,g')"
                        arg="C:''${rel_win}"
                      fi
                      ;;
                  esac

                  new_args+=("$arg")
                done
                set -- "''${new_args[@]}"
              fi
            '';
          }
        ))
      ];
    };
  };
}
