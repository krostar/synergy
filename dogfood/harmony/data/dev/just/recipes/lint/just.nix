{unit, ...}:
unit.lib.just.mkRecipe "linters" "lint-just" {
  _just-check = {
    enable = true;
    recipe = "just --fmt --check";
  };
}
