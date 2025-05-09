{unit, ...}:
unit.lib.just.mkRecipe "linters" "lint-just" {
  just-check = {
    enable = true;
    recipe = "just --fmt --check";
  };
}
