{lib}:
# This function performs a complete transposition of a two-level nested attribute
# set structure, effectively swapping the roles of parent and child keys while
# preserving all data relationships. It's designed to provide alternative access
# patterns to the same data by reorganizing the hierarchical structure.
#
# Transformation Logic:
# For each parent-child relationship in the original structure, the function creates
# a new child-parent relationship in the result. This effectively transposes the
# data matrix while maintaining all original key-value associations.
#
# Conflict Resolution:
# When multiple parents have the same child key, the recursive merging process
# combines them into a single child attribute containing all parent relationships.
# This ensures no data is lost during the transposition process.
#
# Example:
#     swapLevels {
#       user1 = { name = "Alice"; role = "admin"; };
#       user2 = { name = "Bob"; role = "user"; };
#       user3 = { name = "Carol"; role = "admin"; };
#     }
#     => {
#          name = { user1 = "Alice"; user2 = "Bob"; user3 = "Carol"; };
#          role = { user1 = "admin"; user2 = "user"; user3 = "admin"; };
#        }
attrs: (lib.lists.foldl lib.attrsets.recursiveUpdate {} (
  builtins.attrValues (
    builtins.mapAttrs (
      parentKey: parentValue:
        builtins.mapAttrs (
          _: childValue: {"${parentKey}" = childValue;}
        )
        parentValue
    )
    attrs
  )
))
