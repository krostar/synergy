{lib}:
# This function provides recursive merging functionality for combining multiple
# nested attribute sets with intelligent handling of different value types.
# It implements a comprehensive merging strategy that goes beyond simple attribute
# set combination to provide meaningful merge behavior for lists, modules,
# and complex nested structures.
#
# The function implements a sophisticated algorithm that analyzes the types
# of values being merged and applies appropriate merge strategies for each
# case, ensuring that the result maintains semantic correctness across
# different data types and usage patterns.
#
# Merge Strategy Matrix:
#   single value: return as-is (no merging needed)
#   multiple lists: concatenate and deduplicate
#   multiple attr sets: recursive merge (with derivation protection)
#   module types: delegate to NixOS module system
#   mixed/other types: last value wins (conflict resolution)
#
# Examples:
#   List merging:
#     [{ list = [1]; }, { list = [2]; }] -> { list = [1 2]; }
#
#   Nested merging:
#     [{ a.b = 1; }, { a.c = 2; }] -> { a = { b = 1; c = 2; }; }
#
# initially based on https://stackoverflow.com/a/54505212
let
  recursiveMerge = attrList: let
    mergingFunction = attrPath:
      builtins.zipAttrsWith (
        attrName: values:
          if lib.lists.tail values == []
          then lib.lists.head values
          else if lib.lists.all builtins.isList values
          then lib.lists.unique (lib.lists.concatLists values)
          else if (lib.lists.all builtins.isAttrs values) && !(lib.lists.any lib.attrsets.isDerivation values)
          then
            if lib.lists.any (builtins.hasAttr "_type") values
            then lib.modules.mkMerge values
            else (mergingFunction (attrPath ++ [attrName]) values)
          else lib.lists.last values
      );
  in
    mergingFunction [] attrList;
in
  recursiveMerge
