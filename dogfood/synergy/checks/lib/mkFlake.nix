{
  flake,
  lib,
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib) mkFlake;
in
  testEqualContents {
    assertion = "lib.mkFlake";
    actual =
      formatJSON "actual.json"
      (builtins.attrNames
        (mkFlake {
          src = ./modules/_testdata;
          inputs = {
            inherit (flake.inputs) nixpkgs;
            self = 42;
          };
        })
        .synergy
        .synergy
        .result);
    expected = formatJSON "expected.json" ["systemized" "systemless"];
  }
