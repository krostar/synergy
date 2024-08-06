{
  pkgs,
  self,
  synergy-lib,
  ...
}:
synergy-lib.tests.cover {
  inherit pkgs;
  unit = self;
}
