{ lib, config, ... }:
rec {
  selectiveSymLink =
    from: to: paths: opts:
    lib.mkMerge (
      map (filePath: {
        "${to}/${filePath}" = {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath /. + "${from}/${filePath}");
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
