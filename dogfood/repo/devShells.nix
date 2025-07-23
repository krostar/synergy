{
  units,
  pkgs,
  ...
}:
units.harmony.devShells.nix.overrideAttrs (_: prev: {
  nativeBuildInputs =
    prev.nativeBuildInputs
    ++ (with pkgs; [cue scorecard]);
})
