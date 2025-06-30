{
  flake,
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib) mkFlake;
in
  testEqualContents {
    assertion = "lib.mkFlake";
    actual =
      formatJSON "actual.json"
      (
        builtins.attrNames
        (mkFlake {
          src = ./modules/_testdata/test-load;
          inputs = {
            inherit (flake.inputs) nixpkgs;
            self = {};
          };
        })._synergy or {
        }
      );
    expected = formatJSON "expected.json" ["config" "load" "units"];
  }
