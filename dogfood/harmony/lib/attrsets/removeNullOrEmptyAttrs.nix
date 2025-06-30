{lib, ...}: let
  removeNullOrEmptyAttrs = value:
    if builtins.isAttrs value
    then
      lib.attrsets.filterAttrs (
        _: v: let
          notNull = v != null;
          attrsetsNotEmpty = builtins.length (builtins.attrNames v) != 0;
        in
          notNull && (!builtins.isAttrs v || (builtins.isAttrs v && attrsetsNotEmpty))
      ) (builtins.mapAttrs (_: removeNullOrEmptyAttrs) value)
    else if builtins.isList value
    then builtins.map removeNullOrEmptyAttrs value
    else value;
in
  removeNullOrEmptyAttrs
