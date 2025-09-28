{ lib, config, ... }:
rec {
  css = import ./css.nix;

  selectiveSymLink =
    from: to: paths: opts:
    lib.mkMerge (
      map (path: {
        "${to}/${path}" = {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath /. + "${from}/${path}");
        }
        // opts;
      }) paths
    );

  xdgConfigSelectiveSymLink =
    to: paths: opts:
    selectiveSymLink ../../dotfiles/${to} ".config/${to}" paths opts;

  prefixset =
    prefix: kvpairs:
    builtins.mapAttrs (
      name: value: if builtins.typeOf prefix == "lambda" then prefix value else prefix + " " + value
    ) kvpairs;
}
