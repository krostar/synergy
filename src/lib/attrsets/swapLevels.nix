{lib}:
/*
Swaps two levels of attribute sets.

This function takes an attribute set and swaps the keys of the top-level
attribute set with the keys of its direct children.

Example:
  swapLevels { a = { x = 4; }; b = { a = 2; }; }
    => { a = { b = 2; }; x = { a = 4; }; }
*/
attrs: (lib.lists.foldl lib.attrsets.recursiveUpdate {} (
  builtins.attrValues (builtins.mapAttrs (
      k1: v1:
        builtins.mapAttrs (_: v2: {"${k1}" = v2;}) v1
    )
    attrs)
))
