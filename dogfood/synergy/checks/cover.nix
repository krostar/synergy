{
  pkgs,
  unit,
  synergy-lib,
  ...
}:
synergy-lib.tests.cover {
  inherit pkgs unit;
}
