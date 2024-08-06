{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  /*
  If a source path contains both a directory and a file with the same name (except for the file extension), keep only the file.

  Example:
    sources = {
      foo = {
        bar.nix = true;
      };
      foo.nix = true;
    };

    preferFilesOverDirectories "nix" sources
      => {
          foo.nix = true;
        }
  */
  fileExt: sources:
    removeEmptySets (
      let
        mapAttrsRecursive = parent: (lib.attrsets.mapAttrs (
            k: v:
              if builtins.isAttrs v
              then
                ( # if there is in $parent a value similarly named to $k (which value $v is an attrset) ending with $fileExt
                  if lib.attrsets.hasAttrByPath ["${k}.${fileExt}"] parent
                  then {} # then empty out the value k, keeping only value k.$fileExt
                  else (mapAttrsRecursive v)
                )
              else v
          )
          parent);
      in
        mapAttrsRecursive sources
    )
