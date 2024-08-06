{lib}:
/*
Filter out empty attribute sets recursively.

Example:
  removeEmptySets { a = {}; b = { c = 1; }; }
    => { b = { c = 1; }; }
*/
attr:
lib.lists.foldr lib.attrsets.recursiveUpdate {} (
  builtins.map (
    item: lib.attrsets.setAttrByPath item.keys item.value
  ) (
    lib.attrsets.collect (
      value: (builtins.isAttrs value) && (lib.attrsets.attrByPath ["_marker"] false value)
    ) (
      lib.attrsets.mapAttrsRecursive (keys: value: {
        inherit keys value;
        _marker =
          if builtins.isAttrs value
          then builtins.length (builtins.attrNames value) != 0
          else true;
      })
      attr
    )
  )
)
