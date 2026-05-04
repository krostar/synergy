{
  lib,
  units,
  ...
}:
units.harmony.lib.just.mkRecipe "formatters" "fmt" {
  treefmt = {
    enable = true;
    parameters = ["*FILES"];
    recipe = "${lib.meta.getExe units.harmony.packages.treefmt} {{ FILES }}";
  };
}
