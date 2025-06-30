{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  # This function resolves naming conflicts between directories and files
  # by preferring files over directories when they share the same base name.
  # This implements a clear precedence rule that ensures predictable behavior in source collection.
  #
  # Parameters:
  #   fileExt - String specifying the file extension to check for conflicts
  #             (e.g., "nix" to prefer *.nix files over directories)
  #   sources - Nested attribute set representing the source tree structure
  #             Expected to contain attribute sets (directories) and booleans (files)
  # Returns:
  #   Processed attribute set where file vs directory conflicts are resolved
  #   in favor of files, with empty directories cleaned up
  #
  # Examples:
  #     sources = {
  #       config = { "settings.nix" = true; };
  #       "config.nix" = true;
  #       utils = { "helper.nix" = true; };
  #       "utils.nix" = true;
  #       standalone = { "code.nix" = true; };  # No conflict
  #     };
  #
  #     preferFilesOverDirectories "nix" sources
  #     => {
  #          "config.nix" = true;
  #          "utils.nix" = true;
  #          standalone = { "code.nix" = true; };
  #        }
  fileExt: sources:
    removeEmptySets (
      let
        walkThrough = parent: (lib.attrsets.mapAttrs (
            k: v:
              if builtins.isAttrs v
              then
                ( # if there is in $parent a value similarly named to $k (which value $v is an attrset) ending with $fileExt
                  if lib.attrsets.hasAttrByPath ["${k}.${fileExt}"] parent
                  then {} # then empty out the value k, keeping only value k.$fileExt
                  else (walkThrough v)
                )
              else v
          )
          parent);
      in
        walkThrough sources
    )
