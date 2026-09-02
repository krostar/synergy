{
  unit,
  pkgs,
  ...
}:
unit.devShells.base.overrideAttrs (_: prev: {
  nativeBuildInputs =
    prev.nativeBuildInputs
    ++ (with pkgs; [
      opentofu
      tflint
      trivy
    ]);
})
