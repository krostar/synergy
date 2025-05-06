{unit, ...}:
unit.lib.just.mkRecipe "testers" "test-nix" {
  nix-flake = {
    enable = true;
    recipe = "nix flake check --all-systems";
  };
}
