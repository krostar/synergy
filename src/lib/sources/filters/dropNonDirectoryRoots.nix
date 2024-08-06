{root}: let
  inherit (root.attrsets) removeEmptySets;
in
  /*
  Drops root files from the source tree, keeping only root directories.

  Example:
    sources = {
      file1.nix = true;
      dir1 = {
        file2.nix = true;
      };
    };

    dropNonDirectoryRoots sources
      => {
          dir1 = {
            file2.nix = true;
          };
        }
  */
  sources:
    removeEmptySets (
      builtins.mapAttrs (_: value: (
        if builtins.isAttrs value
        then value
        else {}
      ))
      sources
    )
