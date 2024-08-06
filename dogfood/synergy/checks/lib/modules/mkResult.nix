{
  flake,
  lib,
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.modules) mkResult;

  result = mkResult {
    src = ./_testdata;
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
  # TODO: this is a minimal test only to check that overall the lib is working
  # later more test should be added to check:
  # - that dependencies are correctly setup
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
            self = builtins.attrNames loaded.result.lib.unitb.debug.self;
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
            names = ["data" "deps" "flake" "lib" "loaded" "pkgs" "self" "synergy-lib" "units"];
            self = ["lib" "packages"];
            units = ["unita" "unitb"];
          };
          lib = [["foo"] ["debug"] ["printHello"]];
        };
      };
    };
  }
