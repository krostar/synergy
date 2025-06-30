{
  lib,
  root,
}:
# This function provides a custom NixOS module system type that represents
# nested attribute sets of arbitrary depth where all leaf values must be
# of a specific type. Unlike `lib.types.attrsOf` which only handles flat
# attribute sets, this type supports unlimited nesting levels.
#
# The type is particularly useful for configuration systems that need
# hierarchical organization while maintaining type safety at the leaves.
# It allows complex nested structures while ensuring all final values
# conform to the specified type.
#
# Example Usage:
#   options.services = lib.mkOption {
#     type = attrsOfAnyDepthOf lib.types.str;
#     default = {};
#     description = "Nested service configuration";
#   };
#
#   # Allows configurations like:
#   services = {
#     web = {
#       frontend = {
#         nginx = "enabled";
#         ssl = "strict";
#       };
#       backend = {
#         api = "v2";
#       };
#     };
#     database = {
#       primary = "postgresql";
#     };
#   };
let
  inherit (root.attrsets) recursiveMerge;

  attrsOfAnyDepthOf = elemType:
    lib.mkOptionType {
      name = "attrsOfAnyDepthOf";
      description = "attribute set of any depth where leaf elements must be of type ${lib.types.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType}";
      descriptionClass = "composite";
      check = v: builtins.isAttrs v && !(lib.attrsets.isDerivation v);

      merge = loc: defs:
        recursiveMerge (
          builtins.map (def: (
            lib.mapAttrsRecursiveCond
            (v: builtins.isAttrs v && !(lib.attrsets.isDerivation v))
            (
              k: v:
                lib.trivial.throwIfNot (elemType.check v)
                "The definition of option `${lib.showOption loc}' at path `${lib.showOption k}' is not of type ${elemType.description}. Definition value: ${lib.strings.escapeNixString v}"
                v
            )
            def.value
          ))
          defs
        );

      emptyValue = {value = {};};
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);

      inherit (elemType) getSubModules;
      substSubModules = m: attrsOfAnyDepthOf (elemType.substSubModules m);
      nestedTypes.elemType = elemType;
    };
in
  attrsOfAnyDepthOf
