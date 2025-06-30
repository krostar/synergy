{lib}:
# Reads the contents of a directory recursively and returns a structured attribute set.
#
# This function traverses a directory structure and creates an attribute set that mirrors
# the hierarchy of Nix files and directories found. It serves as the foundation for
# the Synergy source collection system, providing the raw structure that filters
# then refine and process.
#
# Parameters:
#   - `dir`: Path to the directory to read recursively
#            Must be a valid filesystem path accessible to Nix
#
# Returns:
#   An attribute set following the directory structure, with keys representing
#   file and directory names. The values are either:
#     - An attribute set, representing a non-empty subdirectory
#     - A boolean `true`, indicating a regular file ending with ".nix"
#     - Non-Nix files and empty directories are excluded
#
# Example:
#   Given directory structure:
#     mydir/
#       config.nix     (regular file)
#       utils.nix      (regular file)
#       subdir/
#         helper.nix   (regular file)
#       empty/         (empty directory)
#       readme.txt     (non-Nix file)
#
#   readSource ./mydir
#   => {
#        "config.nix" = true;
#        "utils.nix" = true;
#        subdir = {
#          "helper.nix" = true;
#        };
#      }
let
  readSource = dir:
    lib.attrsets.filterAttrsRecursive (
      _: value:
        (builtins.isAttrs value && builtins.length (builtins.attrValues value) != 0)
        || builtins.isBool value
    ) (
      lib.attrsets.mapAttrs (
        file: type:
          if type == "directory"
          then readSource "${dir}/${file}"
          else
            (
              type
              == "regular"
              && (builtins.stringLength file) > 4
              && (lib.strings.hasSuffix ".nix" file)
            )
      )
      (builtins.readDir dir)
    );
in
  readSource
