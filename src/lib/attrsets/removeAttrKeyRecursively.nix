{lib}:
# This function provides functionality for recursively removing specified
# attribute keys from complex nested data structures. It implements a
# comprehensive traversal algorithm that can eliminate target keys from
# arbitrarily deep hierarchies while preserving the overall structure
# and all non-target content.
#
# Example:
#     attr = {
#       items = [
#         { name = "item1"; _toremove = "data"; }
#         { name = "item2"; _toremove = "metadata"; }
#       ];
#       _toremove = "global";
#     }
#
#     removeAttributeRecursively "_toremove" attr
#     {
#       items = [
#         { name = "item1"; }
#         { name = "item2"; }
#       ];
#     }
let
  removeAttributeRecursively = keyToRemove: value:
    if builtins.isAttrs value
    then
      lib.attrsets.filterAttrs
      (attributeName: _: attributeName != keyToRemove)
      (
        builtins.mapAttrs
        (_: attributeValue: removeAttributeRecursively keyToRemove attributeValue)
        value
      )
    else if builtins.isList value
    then
      builtins.map
      (listElement: removeAttributeRecursively keyToRemove listElement)
      value
    else value;
in
  removeAttributeRecursively
