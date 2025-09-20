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

      flattened = unit.lib.modules.import {
        inherit source;
        args = {hello = "world";};
        flatten = true;
      };

      merged = unit.lib.modules.import {
        inherit source;
        args = {hello = "world";};
        flatten = true;
        merge = true;
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

      flattened = [
        {
          "a" = true;
        }
        {
          "b1" = true;
        }
        {
          "c" = true;
        }
        {
          "debug" = {
            "args" = [
              "hello"
            ];
          };
        }
      ];

      merged = {
        a = true;
        b1 = true;
        c = true;
        debug.args = ["hello"];
      };
    };
  }
