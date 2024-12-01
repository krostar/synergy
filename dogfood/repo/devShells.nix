{
  pkgs,
  unit,
  ...
}:
pkgs.mkShellNoCC {
  nativeBuildInputs = [unit.formatter];
}
