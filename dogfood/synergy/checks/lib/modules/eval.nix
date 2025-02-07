{
  flake,
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) eval;
in
  # TODO: this is a minimal test only to check that overall the lib is working
  # later more test should be added to check:
  # - that collectors are correctly applied after initial load
  testEqualContents {
    assertion = "lib.modules.eval";
    actual = let
      evaled = eval {
        src = ./_testdata;
        inputs = {
          inherit (flake.inputs) nixpkgs;
          self = 42;
        };
      };
    in
      formatJSON "actual.json" {
        result = builtins.attrNames evaled.config.synergy.result;
        lib = builtins.attrNames evaled.config.synergy.result.systemless.lib;
      };
    expected = formatJSON "expected.json" {
      result = ["systemized" "systemless"];
      lib = ["unita" "unitb"];
    };
  }
