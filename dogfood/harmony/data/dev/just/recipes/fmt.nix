{
  lib,
  unit,
  ...
}:
unit.lib.just.mkRecipe "formatters" "fmt" {
  treefmt = {
    enable = true;
    attributes = ["positional-arguments"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe unit.packages.treefmt} "$@"
    '';
  };
}
