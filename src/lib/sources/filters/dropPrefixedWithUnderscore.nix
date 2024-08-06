{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  /*
  Recursively removes attributes from a set whose keys start with an underscore.

  Example:
    sources = {
      a = true;
      _b = true;
      c = {
        _d = true;
        e = true;
      };
    };

    dropPrefixedWithUnderscore sources
      => {
          a = true;
          c = {
            e = true;
          };
        }
  */
  sources:
    removeEmptySets (
      lib.attrsets.filterAttrsRecursive (
        key: _: !(lib.strings.hasPrefix "_" key)
      )
      sources
    )
