{lib}:
# This function implements a recursive key transformation system that applies a custom
# renaming function to every attribute key throughout a nested structure. It preserves
# all values and hierarchical relationships while providing complete control over key
# naming patterns and transformations.
#
# Examples:
#   Simple prefix addition:
#     renameAttrKeys (key: "app_${key}") {
#       config = { debug = true; };
#       users = { admin = "alice"; };
#     }
#     => {
#          app_config = { app_debug = true; };
#          app_users = { app_admin = "alice"; };
#        }
#
#   Case transformation:
#     renameAttrKeys (key: lib.strings.toLower key) {
#       FirstName = "John";
#       LastName = "Doe";
#       ContactInfo = {
#         Email = "john@example.com";
#         Phone = "123-456-7890";
#       };
#     }
#     => {
#          firstname = "John";
#          lastname = "Doe";
#          contactinfo = {
#            email = "john@example.com";
#            phone = "123-456-7890";
#          };
#        }
renamer: let
  renameAttrKeys = attr:
    lib.attrsets.mapAttrs' (
      originalKey: originalValue: (
        lib.attrsets.nameValuePair
        (renamer originalKey)
        (
          if builtins.isAttrs originalValue
          then (renameAttrKeys originalValue)
          else originalValue
        )
      )
    )
    attr;
in
  renameAttrKeys
