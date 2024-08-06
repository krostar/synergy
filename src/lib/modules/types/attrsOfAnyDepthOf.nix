{
  lib,
  root,
}: let
  inherit (root.attrsets) recursiveMerge;

  attrsOfAnyDepthOf = elemType:
    lib.mkOptionType {
      name = "attrsOfAnyDepthOf";
      description = "attribute set of any depth where leaf elements must be of type ${lib.types.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType}";
      descriptionClass = "composite";
      check = v: builtins.isAttrs v && !(lib.attrsets.isDerivation v);
      merge = loc: defs:
        recursiveMerge (builtins.map (def: (lib.mapAttrsRecursiveCond (v: builtins.isAttrs v && !(lib.attrsets.isDerivation v)) (
            k: v:
              lib.trivial.throwIfNot (elemType.check v)
              "The definition of option `${lib.showOption loc}' at path `${lib.showOption k}' is not of type ${elemType.description}. Definition value: ${lib.strings.escapeNixString v}"
              v
          )
          def.value))
        defs);
      emptyValue = {value = {};};
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);

      inherit (elemType) getSubModules;
      substSubModules = m: attrsOfAnyDepthOf (elemType.substSubModules m);
      nestedTypes.elemType = elemType;
    };
in
  /*
  Defines an option type that accepts an attribute set of any depth, where the leaf elements must be of a specific type.


  Example:
    options = {
      myOption = attrsOfAnyDepthOf lib.types.str;
    };

    This defines an option "myOption" that accepts values like:
      { a = "foo"; }
      { a = "foo"; b = { c = "bar"; }; }
    but would reject values like:
      { a = 123; }
      { a = "foo"; b = { c = 123; }; }
  */
  attrsOfAnyDepthOf
