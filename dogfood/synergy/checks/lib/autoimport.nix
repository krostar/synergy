{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib) autoimport;
in
  testEqualContents {
    assertion = "lib.modules.import";
    actual = formatJSON "actual.json" {
      not-squashed = autoimport {
        source = ./modules/_testdata/test-import;
        args = {
          hello = "workd";
          _synergy = {
            unitName = "unit-not-squashed";
            moduleName = "mymodule";
          };
        };
      };

      squashed = autoimport {
        source = ./modules/_testdata/test-import;
        args = {
          hello = "workd";
          _synergy = {
            unitName = "unit-squashed";
            moduleName = "mymodule";
          };
        };
        squash = true;
      };
    };
    expected = formatJSON "expected.json" {
      not-squashed = {
        a.a = true;
        b.b1.b1 = true;
        c.c = true;
        debug.debug = {
          args = ["_synergy" "hello"];
          synergy = {
            unitName = "unit-not-squashed";
            moduleName = "mymodule";
          };
        };
      };

      squashed = {
        a = true;
        b1 = true;
        c = true;
        debug = {
          args = ["_synergy" "hello"];
          synergy = {
            unitName = "unit-squashed";
            moduleName = "mymodule";
          };
        };
      };
    };
  }
