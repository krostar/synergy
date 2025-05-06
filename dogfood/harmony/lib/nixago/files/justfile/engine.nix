{
  pkgs,
  lib,
  ...
}: {
  data,
  output,
  ...
}: let
  reIndentString = indent: str:
    lib.strings.removeSuffix "${indent}\n" (
      lib.strings.concatMapStrings (line: "${indent}${line}\n") (lib.strings.splitString "\n" str)
    );

  generateRecipe = {
    comment ? null,
    documentation ? null,
    attributes ? [],
    groups ? [],
    name,
    parameters ? [],
    dependencies ? [],
    recipe ? null,
  }: let
    formatComment =
      if comment != null
      then "# ${comment}\n"
      else "";

    formatDoc =
      if documentation != null
      then "[doc('${documentation}')]\n"
      else "";

    formatGroups =
      if builtins.length groups > 0
      then lib.strings.concatMapStrings (group: "[group('${group}')]\n") (lib.lists.sort (p: q: p < q) groups)
      else "";

    formatAttrs =
      if builtins.length attributes > 0
      then "[${builtins.concatStringsSep ", " attributes}]\n"
      else "";

    formatParams =
      if builtins.length parameters > 0
      then " ${builtins.concatStringsSep " " parameters}"
      else "";

    formatDeps =
      if builtins.length dependencies > 0
      then ": ${builtins.concatStringsSep " " dependencies}"
      else ":";
  in ''
    ${formatComment}${formatDoc}${formatGroups}${formatAttrs}${name}${formatParams}${formatDeps}
    ${
      if recipe != null
      then (reIndentString "    " recipe)
      else ""
    }
  '';

  generateJustfile = {
    module ? null,
    imports ? [],
    settings ? {},
    pre-recipes ? null,
    default ? null,
    recipes ? [],
    post-recipes ? null,
  }: let
    formatModule =
      if module != null
      then "mod ${module}\n\n"
      else "";

    formatImports =
      if builtins.length imports > 0
      then lib.concatMapStrings "\n" (imp: "import \"${imp}") imports + "\n\n"
      else "";

    formatSettings =
      if builtins.length (builtins.attrNames settings) > 0
      then
        lib.strings.concatLines (lib.attrsets.mapAttrsToList
          (name: value: "set ${name} := ${value}")
          settings)
        + "\n"
      else "";

    formatAliases = let
      aliases = lib.lists.flatten (
        lib.attrsets.mapAttrsToList (
          name: recipe:
            builtins.map (alias: {
              from = alias;
              to = name;
            })
            recipe.aliases
        ) (lib.attrsets.filterAttrs (_: recipe: recipe.enable && builtins.length recipe.aliases > 0) recipes)
      );
    in
      if builtins.length aliases > 0
      then lib.strings.concatLines (builtins.map (alias: "alias ${alias.from} := ${alias.to}") aliases) + "\n"
      else "";

    formatPreRecipes =
      if pre-recipes != null
      then pre-recipes + "\n\n"
      else "";

    formatDefault =
      if default != null
      then ''
        _default:
        ${reIndentString "    " default}
      ''
      else "";

    formatRecipes = lib.strings.removeSuffix "\n" (lib.strings.concatStrings (
      lib.attrsets.mapAttrsToList (
        name: recipe:
          generateRecipe
          (builtins.removeAttrs (recipe // {inherit name;}) ["enable" "aliases"])
      )
      (lib.attrsets.filterAttrs (_: recipe: recipe.enable) recipes)
    ));

    formatPostRecipes =
      if post-recipes != null
      then post-recipes + "\n"
      else "";
  in
    formatModule + formatImports + formatSettings + formatAliases + formatPreRecipes + formatDefault + formatRecipes + formatPostRecipes;
in
  pkgs.writeTextFile {
    name = output;
    text = generateJustfile data;
  }
