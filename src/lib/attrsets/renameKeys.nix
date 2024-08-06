{lib}:
/*
Recursively renames keys in an attribute set using a provided renamer function.

Example:
  renameKeys (key: "prefix-${key}") { a = 1; b = { c = 2; }; }
    => { prefix-a = 1; prefix-b = { prefix-c = 2; }; }
*/
renamer: let
  renameKeys = set:
    lib.attrsets.mapAttrs' (key: value: (
      lib.attrsets.nameValuePair (renamer key) (
        if builtins.isAttrs value
        then (renameKeys value)
        else value
      )
    ))
    set;
in
  renameKeys
