{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  /*
  Filters out all non-regular files or files not ending with .nix from a source tree.

  Example:
    sources = {
      foo.nix = true;
      bar = {
        baz.nix = false;
        qux.nix = true;
      };
    };

    validNixFilesOnly sources
      => {
          foo.nix = true;
          bar = {
            qux.nix = true;
          };
        }
  */
  sources:
    removeEmptySets (
      lib.attrsets.filterAttrsRecursive (
        _: value:
          builtins.isAttrs value || (builtins.isBool value && value)
      )
      sources
    )
