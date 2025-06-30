{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) collect load;

  loaded =
    load {
      sources = collect ./_testdata/test-load;
      args = {hello = "world";};
    }
    null;
in
  testEqualContents {
    assertion = "lib.modules.load";
    actual = formatJSON "actual.json" {
      units = builtins.attrNames loaded;
      modules = builtins.mapAttrs (_: value: builtins.attrNames value) loaded;
      args = {
        names = builtins.attrNames loaded.unitb.lib.debug;
        units = loaded.unitb.lib.debug.units == loaded;
      };
      libA = builtins.attrNames loaded.unita.lib;
      libB = builtins.attrNames loaded.unitb.lib;
      libAFoo = builtins.attrNames loaded.unita.lib.foo;
    };
    expected = formatJSON "expected.json" {
      units = ["unita" "unitb"];
      modules = {
        unita = ["formatter" "lib" "packages"];
        unitb = ["lib" "packages"];
      };
      args = {
        names = [
          "hello"
          "synergy-lib"
          "unit"
          "units"
        ];
        units = true;
      };
      libA = ["foo"];
      libB = ["debug"];
      libAFoo = ["printHello"];
    };
  }
