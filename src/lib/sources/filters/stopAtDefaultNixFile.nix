{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  /*
  If a directory contains a regular Nix file named "default.nix", only keep that file.

  This function recursively traverses a source tree and, for each directory,
  checks if it contains a regular file named "default.nix". If it does, the
  directory's contents are dropped, keeping only the "default.nix" file.

  Example:
    sources = {
      dir1 = {
        file1.nix = true;
        default.nix = true;
        dir2 = {
          file2.nix = true;
        };
      };
    };

    stopAtDefaultNixFile sources
      => {
          dir1 = {
            default.nix = true;
          };
        }
    ```
  */
  sources: let
    replaceCond = attrs:
      builtins.isAttrs attrs
      && builtins.hasAttr "default.nix" attrs
      && builtins.isBool attrs."default.nix";
  in
    if replaceCond sources
    then {"default.nix" = sources."default.nix";}
    else
      (
        removeEmptySets (
          lib.attrsets.mapAttrsRecursiveCond (attrs: !(builtins.hasAttr "default.nix" attrs)) (
            _: value: (
              if replaceCond value
              then {"default.nix" = value."default.nix";}
              else value
            )
          )
          sources
        )
      )
