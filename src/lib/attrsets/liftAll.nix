{lib}:
# Recursively lifts name/value pairs from nested attribute sets to the top level,
# joining nested attribute names with the given separator.
#
# This function performs deep flattening of nested attribute set structures,
# converting hierarchical organization into flat key-value mappings. It's designed
# to handle complex nested structures while preserving the logical relationships
# between keys and values through composite naming.
#
# Derivation Handling:
# The function specifically avoids recursing into derivations, treating them as
# atomic values. This prevents the flattening process from attempting to process
# internal derivation attributes, which could be large, complex, or inappropriate
# for flattening operations.
#
# Parameters:
#   separator - string used to join nested attribute names in composite keys
#               Common choices: ".", "-", "_"
#
#   attrs - nested attribute set to flatten
#           can contain arbitrary levels of nesting with mixed value types
#           derivations are treated as atomic values and not recursed into
#           empty attribute sets are processed but may not contribute to output
#
# Example:
#     liftAll "." {
#       database = {
#         host = "localhost";
#         port = 5432;
#       };
#       cache = {
#         redis = {
#           url = "redis://localhost";
#         };
#       };
#     }
#     => {
#          "database.host" = "localhost";
#          "database.port" = 5432;
#          "cache.redis.url" = "redis://localhost";
#        }
let
  liftAll = separator: attrs:
    lib.lists.foldl
    (accumulator: nameValuePair: accumulator // {"${nameValuePair.name}" = nameValuePair.value;})
    {}
    (
      lib.attrsets.collect
      (
        item:
          builtins.isAttrs item
          && builtins.length (lib.lists.subtractLists (builtins.attrNames item) ["name" "value"]) == 0
      )
      (
        lib.mapAttrsRecursiveCond
        (
          value:
            builtins.isAttrs value
            && !(lib.attrsets.isDerivation value)
        )
        (
          keys: value:
            lib.attrsets.nameValuePair
            (lib.strings.concatStringsSep separator keys)
            value
        )
        attrs
      )
    );
in
  liftAll
