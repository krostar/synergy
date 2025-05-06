{lib, ...}: group: name: commands: let
  recipes =
    lib.attrsets.filterAttrs (_: recipe: recipe.enable)
    (lib.attrsets.mapAttrs' (k: v:
      lib.attrsets.nameValuePair "_run-${k}" (v
        // {
          groups = (v.groups or []) ++ [group];
        }))
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
