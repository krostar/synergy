{lib}:
/*
Lifts name/value pairs from a nested attribute set one level up,
  joining the parent and child attribute names with the given separator.

This function ignores derivations.

Example:
  liftChildren "-" {a = {b = 1;}; c = {d = 2;};}
    => {a-b = 1; c-d = 2;}
*/
let
  liftChildren = separator: attrs: (lib.lists.foldl (a: n: a // n) {} (
    builtins.attrValues (
      builtins.mapAttrs (
        k: v: (
          lib.attrsets.mapAttrs' (
            kk: vv: (lib.attrsets.nameValuePair "${k}${separator}${kk}" vv)
          )
          v
        )
      )
      attrs
    )
  ));
in
  liftChildren
