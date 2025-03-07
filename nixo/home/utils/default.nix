{ lib, config, ... }:
{
  css = import ./css.nix;

  selectiveSymLink =
    from: to: paths: opts:
    lib.mkMerge (
      map (path: {
        "${to}/${path}" = {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath /. + "${from}/${path}");
        } // opts;
      }) paths
    );

  prefixset =
    prefix: kvpairs:
    builtins.mapAttrs (
      name: value: if builtins.typeOf prefix == "lambda" then prefix value else prefix + " " + value
    ) kvpairs;

}
