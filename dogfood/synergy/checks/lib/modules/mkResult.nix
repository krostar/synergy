{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) mkResult;

  result = mkResult {
    src = ./_testdata/test-load;
    inputs = {
      self = {
        outPath = "myOutPath";
        narHash = "myNarHash";
        something = 42;
      };
      foo._synergy = {};
    };
  };
in
  testEqualContents {
    assertion = "lib.modules.mkResult";
    actual = formatJSON "actual.json" {
      inherit (result) flake;
      load = let
        loaded = result.load {} pkgs;
      in {
        result = {
          modules = builtins.attrNames loaded.result;
          units = builtins.mapAttrs (_: v: builtins.attrNames v) loaded.result;
          args = {
            names = builtins.attrNames loaded.result.lib.unitb.debug;
            unit = builtins.attrNames loaded.result.lib.unitb.debug.unit;
            units = builtins.attrNames loaded.result.lib.unitb.debug.units;
          };
          lib = [
            (builtins.attrNames loaded.result.lib.unita)
            (builtins.attrNames loaded.result.lib.unitb)
            (builtins.attrNames loaded.result.lib.unita.foo)
          ];
        };
      };
    };
    expected = formatJSON "expected.json" {
      flake = {
        outPath = "myOutPath";
        narHash = "myNarHash";
        inputs = {
          foo._synergy = {};
        };
        outputs = {
          outPath = "myOutPath";
          something = 42;
        };
      };

      load = {
        result = {
          modules = ["formatter" "lib" "packages"];
          units = {
            formatter = ["unita"];
            lib = ["unita" "unitb"];
            packages = ["unita" "unitb"];
          };
          args = {
            names = ["_synergy" "data" "deps" "flake" "lib" "pkgs" "results" "synergy-lib" "unit" "units"];
            unit = ["lib" "packages"];
            units = ["unita" "unitb"];
          };
          lib = [["foo"] ["debug"] ["printHello"]];
        };
      };
    };
  }
