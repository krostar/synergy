{lib}:
/*
Recursively lifts name/value pairs from nested attribute sets to the top level,
  joining nested attribute names with the given separator.

This function does not recurse into derivations.

Example:
  liftAll "-" {a = {b = 1;}; c = {d = 2;};}
    => {a-b = 1; c-d = 2;}
*/
let
  liftAll = separator: attrs:
    lib.lists.foldl (a: n: a // {"${n.name}" = n.value;}) {} (
      lib.attrsets.collect (x: builtins.isAttrs x && (builtins.length (lib.lists.subtractLists (builtins.attrNames x) ["name" "value"]) == 0)) (
        lib.mapAttrsRecursiveCond (x: builtins.isAttrs x && !(lib.attrsets.isDerivation x)) (
          keys: value:
            lib.attrsets.nameValuePair (lib.strings.concatStringsSep separator keys) value
        )
        attrs
      )
    );
in
  liftAll
