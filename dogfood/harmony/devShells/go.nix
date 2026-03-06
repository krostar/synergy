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
      go_1_26
      gops
      gotools
      govulncheck
    ]);
})
