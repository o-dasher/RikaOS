{
  css = import ./css.nix;
  prefixset =
    prefix: kvpairs:
    builtins.mapAttrs (
      name: value: if builtins.typeOf prefix == "lambda" then prefix value else prefix + " " + value
    ) kvpairs;
}
