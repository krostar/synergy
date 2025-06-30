{lib}:
# This function performs the final transformation in the source collection pipeline,
# converting abstract source tree structures into concrete filesystem paths. It
# traverses the nested attribute set structure and constructs proper file paths
# by combining the base path with the hierarchical key structure.
#
# This transformation is essential for module loading, as it provides the actual
# filesystem locations where source files can be found. The function maintains
# the hierarchical organization while making the sources addressable.
#
# Parameters:
#   basePath - String representing the absolute base path to prepend to all sources
#              This should be the root directory containing the synergy sources
#              Must be a valid filesystem path accessible during evaluation
#
#   sources - Nested attribute set representing the filtered source tree structure
#
# Returns:
#   Attribute set with identical structure to the input, but with boolean values
#   replaced by absolute filesystem paths constructed from basePath + key hierarchy
#
# Example:
#     basePath = "/project/synergy";
#     sources = {
#       services = {
#         "api.nix" = true;
#         database = {
#           "schema.nix" = true;
#         };
#       };
#       "main.nix" = true;
#     };
#
#     collect basePath sources
#     => {
#          services = {
#            "api.nix" = "/project/synergy/services/api.nix";
#            database = {
#              "schema.nix" = "/project/synergy/services/database/schema.nix";
#            };
#          };
#          "main.nix" = "/project/synergy/main.nix";
#        }
basePath: sources:
lib.attrsets.mapAttrsRecursive (keys: _: basePath + "/${builtins.concatStringsSep "/" keys}") sources
