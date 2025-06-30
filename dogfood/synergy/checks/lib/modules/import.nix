{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) collect;
in
  testEqualContents {
    assertion = "lib.modules.import";
    actual = formatJSON "actual.json" (let
      source = collect ./_testdata/test-import;
    in {
      systemless = unit.lib.modules.import {
        inherit source;
        args = {hello = "world";};
      };

      systemized = unit.lib.modules.import {
        inherit source;
        args = {
          hello = "world";
          inherit pkgs;
        };
      };

      squashed = unit.lib.modules.import {
        inherit source;
        args = {hello = "world";};
        squash = true;
      };
    });
    expected = formatJSON "expected.json" {
      systemless = {
        a.a = true;
        b.b1.b1 = true;
        c.c = true;
        debug.debug.args = ["hello"];
      };

      systemized = {
        a.a = true;
        b.b1.b1 = true;
        c.c = true;
        debug.debug.args = ["hello" "pkgs"];
      };

      squashed = {
        a = true;
        b1 = true;
        c = true;
        debug.args = ["hello"];
      };
    };
  }
