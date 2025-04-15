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
