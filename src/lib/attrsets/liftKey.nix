{lib}:
/*
Recursively lifts a nested attribute with the given key to the top level.

Example:
  liftKey "key" {a = 1; key = {b = 2;};}
    => {a = 1; b = 2;}

  liftKey "key" {a = 1; key = {b = 2; key = {c = 3;};};}
    => {a = 1; key = {b = 2; c = 3};}
    => {a = 1; b = 2; c = 3;}
*/
let
  liftKey = key: attrs:
    if (builtins.isAttrs attrs)
    then
      (
        if (lib.attrsets.hasAttrByPath [key] attrs)
        then let
          keyValue = attrs.${key};
          newValue =
            if (builtins.isAttrs keyValue)
            then (liftKey key keyValue)
            else keyValue;
        in
          if (builtins.isAttrs newValue)
          then (builtins.removeAttrs attrs [key]) // newValue
          else newValue
        else (lib.attrsets.mapAttrs (_: value: (liftKey key value)) attrs)
      )
    else attrs;
in
  liftKey
