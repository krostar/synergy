{lib, ...}: group: name: commands: let
  recipes =
    lib.attrsets.filterAttrs (_: recipe: recipe.enable)
    (lib.attrsets.mapAttrs' (k: v:
      lib.attrsets.nameValuePair "_run-${lib.strings.removePrefix "_" k}" (v // {groups = (v.groups or []) ++ [group];}))
    commands);

  recipesParameters =
    builtins.mapAttrs (
      _: v:
        builtins.map (p: {
          name = lib.strings.removePrefix "+" (lib.strings.removePrefix "*" (builtins.head (lib.strings.splitString "=" p)));
          optional = (lib.strings.hasPrefix "+" p) || (lib.strings.hasPrefix "*" p);
        }) (builtins.filter (v: !(lib.strings.hasPrefix "$" v)) (v.parameters or []))
    )
    recipes;
in
  recipes
  // {
    "${name}" = {
      enable = builtins.length (builtins.attrNames recipes) > 0;
      groups = [group];
      dependencies = lib.attrsets.mapAttrsToList (k: _: let
        recipeParameters = recipesParameters.${k};
      in
        if builtins.length recipeParameters > 0
        then "(${k} ${lib.strings.concatStringsSep " " (builtins.map (p: p.name) recipeParameters)})"
        else k)
      recipes;
      parameters = lib.lists.unique (lib.lists.flatten (lib.attrsets.mapAttrsToList (k: _: let
        recipeParameters = recipesParameters.${k};
      in
        builtins.map (p:
          if p.optional
          then "*${p.name}"
          else p.name)
        recipeParameters)
      recipesParameters));
    };
  }
