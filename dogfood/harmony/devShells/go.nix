{
  unit,
  pkgs,
  ...
}:
unit.devShells.base.overrideAttrs (_: prev: {
  nativeBuildInputs =
    prev.nativeBuildInputs
    ++ (with pkgs; [
      binsider
      cyclonedx-gomod
      go_1_25
      gops
      gotools
      govulncheck
    ]);
})
