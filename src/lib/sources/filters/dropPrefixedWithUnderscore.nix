{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  # This function implements a privacy convention where any attribute (file or
  # directory) whose name begins with an underscore character is considered
  # private and excluded from the final source tree. The filtering is applied
  # recursively throughout the entire structure.
  #
  # Privacy Detection Logic:
  # - uses string prefix matching to identify private attributes
  # - applies the "_" prefix rule consistently at all nesting levels
  # - removes both private files and private directories entirely
  #
  # Examples:
  #     sources = {
  #       api = {
  #         "handlers.nix" = true;  # kept
  #         "_internal.nix" = true; # removed
  #       };
  #       "_experimental" = {       # entirely removed
  #         "feature.nix" = true;
  #       };
  #       utils = {
  #         "common.nix" = true;    # kept
  #       };
  #     };
  #
  #     dropPrefixedWithUnderscore sources
  #     => {
  #          api = {
  #            "handlers.nix" = true;
  #          };
  #          utils = {
  #            "common.nix" = true;
  #          };
  #        }
  sources:
    removeEmptySets (lib.attrsets.filterAttrsRecursive (
        key: _:
          !(lib.strings.hasPrefix "_" key)
      )
      sources)
