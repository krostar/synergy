{
  lib,
  unit,
  ...
}:
unit.lib.just.mkRecipe "formatters" "fmt" {
  treefmt = {
    enable = true;
    parameters = ["*FILES"];
    recipe = "${lib.meta.getExe unit.packages.treefmt} {{ FILES }}";
  };
}
