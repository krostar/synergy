{root}: let
  inherit (root.attrsets) removeEmptySets;
in
  # This function provides filtering functionality to exclude root-level files
  # from source trees, preserving only root-level directories and their contents.
  # It's designed to support unit-based organization where the root level should
  # only contain unit directories.
  #
  # Example:
  #   Input structure:
  #     {
  #       file1.nix = true;        # Root file - will be removed
  #       config.nix = true;       # Root file - will be removed
  #       dir1 = {                 # Root directory - will be kept
  #         file2.nix = true;      # Nested file - preserved
  #         subdir = {             # Nested directory - preserved
  #           file3.nix = true;
  #         };
  #       };
  #       dir2 = {};               # Empty directory - will be removed by cleanup
  #     }
  #
  #   Result:
  #     {
  #       dir1 = {
  #         file2.nix = true;
  #         subdir = {
  #           file3.nix = true;
  #         };
  #       };
  #     }
  sources:
    removeEmptySets (
      builtins.mapAttrs (_: value: (
        if builtins.isAttrs value
        then value
        else {}
      ))
      sources
    )
