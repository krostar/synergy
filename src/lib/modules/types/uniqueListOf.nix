{lib}:
# This function behaves similarly to `lib.types.listOf`, but it ensures that all
# elements in the list are unique by removing duplicates and sorting the result.
# The deduplication happens during the merge phase of module evaluation, making
# it safe to use across multiple module definitions.
#
# Arguments:
#   elemType - The type of elements that the list should contain
#              Can be any valid NixOS module system type (str, int, package, etc.)
#
# Example:
#     options.tags = lib.mkOption {
#       type = uniqueListOf lib.types.str;
#       default = [];
#     };
#
#     # Usage: tags = [ "web" "api" "web" "database" ];
#     # Result: [ "api" "database" "web" ]
#
# Merge Behavior:
#   When multiple definitions are provided across different modules, the type will:
#   1. collect all values from all definitions
#   2. merge them using the base listOf merge logic
#   3. remove duplicate elements using lib.lists.unique
#   4. sort the result for consistent ordering
let
  uniqueListOf = elemType: let
    listOf = lib.types.listOf elemType;
  in
    # extend the base type with unique list behavior
    # we inherit most properties but override specific ones for uniqueness
    listOf
    // {
      description = "list of unique ${lib.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType}";
      substSubModules = m: uniqueListOf (elemType.substSubModules m);

      merge = loc: defs:
        lib.lists.sort
        # sorting comparison function - uses standard less-than comparison
        # this works for strings, numbers, and other comparable types
        (a: b: a < b)
        # deduplication step - removes duplicate elements
        # applied after the base merge to ensure all values are collected first
        (lib.lists.unique (listOf.merge loc defs));
    };
in
  uniqueListOf
