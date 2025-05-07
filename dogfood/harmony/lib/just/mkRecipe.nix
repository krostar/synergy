{lib, ...}: group: name: commands: let
  recipes =
    lib.attrsets.filterAttrs (_: recipe: recipe.enable)
    (lib.attrsets.mapAttrs' (k: v:
      lib.attrsets.nameValuePair (
        if lib.strings.hasPrefix "_" k
        then "_run-${lib.strings.removePrefix "_" k}"
        else "run-${k}"
      ) (v // {groups = (v.groups or []) ++ [group];}))
    commands);

  recipesNames = builtins.attrNames recipes;
in
  recipes
  // {
    "${name}" = {
      enable = builtins.length recipesNames > 0;
      groups = [group];
      dependencies = recipesNames;
    };
  }
