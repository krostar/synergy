{lib}: let
  uniqueListOf = elemType: let
    listOf = lib.types.listOf elemType;
  in
    listOf
    // {
      description = "list of unique ${lib.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType}";
      substSubModules = m: uniqueListOf (elemType.substSubModules m);
      merge = loc: defs: lib.lists.sort (a: b: a < b) (lib.lists.unique (listOf.merge loc defs));
    };
in
  /*
  Defines an option type that represents a list of unique elements of a specific type.

  This function behaves similarly to `lib.types.listOf`, but it ensures that all elements in the list are unique bu removing duplicates.

  Example:
    options = {
      myOption = uniqueListOf lib.types.str;
    };

    This defines an option "myOption" that accepts values like:
      [ "foo" "bar" "foo" ]
    and would produce something like:
      [ "foo" "bar" ]
  */
  uniqueListOf
