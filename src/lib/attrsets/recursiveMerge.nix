# based on https://stackoverflow.com/a/54505212
{lib}:
/*
Merges list of records, concatenates arrays, if two values can't be merged - the latter is preferred

Example 1:
  recursiveMerge [
    { a = "x"; c = "m"; list = [1]; }
    { a = "y"; b = "z"; list = [2]; }
  ]

  returns

  { a = "y"; b = "z"; c="m"; list = [1 2] }

Example 2:
  recursiveMerge [
    {
      a.a = [1];
      a.b = 1;
      a.c = [1 1];
      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/hda";
    }
    {
      a.a = [2];
      a.b = 2;
      a.c = [1 2];
      boot.loader.grub.device = "";
    }
  ]

  returns

  {
    a = {
      a = [ 1 2 ];
      b = 2;
      c = [ 1 2 ];
    };
    boot = {
      loader = {
        grub = {
          device = "";
          enable = true;
        };
      };
    };
  }
*/
let
  recursiveMerge = attrList: let
    f = attrPath:
      builtins.zipAttrsWith (
        n: values:
          if lib.lists.tail values == []
          then lib.lists.head values
          else if lib.lists.all builtins.isList values
          then lib.lists.unique (lib.lists.concatLists values)
          else if (lib.lists.all builtins.isAttrs values) && !(lib.lists.any lib.attrsets.isDerivation values)
          then
            if lib.lists.any (builtins.hasAttr "_type") values
            then lib.modules.mkMerge values
            else (f (attrPath ++ [n]) values)
          else lib.lists.last values
      );
  in
    f [] attrList;
in
  recursiveMerge
