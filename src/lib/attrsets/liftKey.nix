{lib}:
# This function implements a recursive lifting algorithm that searches for
# attributes with a specified key name throughout a nested structure and
# promotes their contents to higher levels in the hierarchy. The process
# continues recursively until no more instances of the target key can be found.
#
# Conflict resolution:
#   The function handles conflicts through merging when lifted attribute sets
#   encounter existing attributes at the parent level. The lifted content takes
#   precedence in conflicts, effectively implementing an override pattern.
#
# Parameters:
#   key - string specifying the attribute name to lift recursively
#         this key will be searched for throughout the nested structure
#
#   attrs - nested attribute set from which to lift the specified key
#           can contain arbitrary levels of nesting with mixed content
#           the function will traverse all attribute set values recursively
#           non-attribute-set values are preserved unchanged
#
# Example:
#     liftKey "default" {
#       name = "myapp";
#       default = {
#         debug = true;
#         port = 8080;
#       };
#       other = "preserved";
#     }
#     => {
#          name = "myapp";
#          debug = true;
#          port = 8080;
#          other = "preserved";
#        }
let
  liftKey = targetKey: inputAttrs:
    if (builtins.isAttrs inputAttrs)
    then
      (
        if (lib.attrsets.hasAttrByPath [targetKey] inputAttrs)
        then let
          targetKeyValue = inputAttrs.${targetKey};

          processedKeyValue =
            if (builtins.isAttrs targetKeyValue)
            then (liftKey targetKey targetKeyValue)
            else targetKeyValue;
        in
          if (builtins.isAttrs processedKeyValue)
          then (builtins.removeAttrs inputAttrs [targetKey]) // processedKeyValue
          else processedKeyValue
        else
          (
            lib.attrsets.mapAttrs
            (_: value: (liftKey targetKey value))
            inputAttrs
          )
      )
    else inputAttrs;
in
  liftKey
