{lib}:
# This function performs single-level flattening of nested attribute
# sets, creating composite keys from immediate parent-child relationships while
# preserving any deeper nesting structure. It's designed for scenarios where
# you need to flatten just the top level of hierarchy without affecting deeper
# organizational structures.
#
# Parameters:
#   separator - String used to join parent and child attribute names
#               common choices: ".", "-", "_"
#
#   attrs - two-level nested attribute set to lift
#           expected to have a structure like { parent1 = { child1 = value1; }; }
#           deeper nesting within child values is preserved unchanged
#           non-attribute-set values at the parent level are ignored
#
# Example:
#     liftChildren "-" {
#       services = {
#         web = {
#           config = { port = 8080; ssl = { enabled = true; }; };
#           health = "/health";
#         };
#         api = {
#           endpoints = ["/users" "/posts"];
#         };
#       };
#     }
#     => {
#          "services-web" = {
#            config = { port = 8080; ssl = { enabled = true; }; };
#            health = "/health";
#          };
#          "services-api" = {
#            endpoints = ["/users" "/posts"];
#          };
#        }
let
  liftChildren = separator: attrs: (
    lib.lists.foldl
    (accumulator: parentResult: accumulator // parentResult)
    {}
    (
      builtins.attrValues (builtins.mapAttrs
        (
          parentKey: parentValue: (
            lib.attrsets.mapAttrs'
            (
              childKey: childValue: (
                lib.attrsets.nameValuePair
                "${parentKey}${separator}${childKey}"
                childValue
              )
            )
            parentValue
          )
        )
        attrs)
    )
  );
in
  liftChildren
