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
      go_1_24
      gotools
      govulncheck
    ]);
})
