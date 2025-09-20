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
    assertion = "lib.autoimport";
    actual = formatJSON "actual.json" {
      not-flattened = autoimport {
        source = ./modules/_testdata/test-import;
        args.hello = "world";
      };

      flattened = autoimport {
        source = ./modules/_testdata/test-import;
        args.hello = "world";
        flatten = true;
      };

      merged = autoimport {
        source = ./modules/_testdata/test-import;
        args.hello = "world";
        flatten = true;
        merge = true;
      };
    };
    expected = formatJSON "expected.json" {
      not-flattened = {
        a.a = true;
        b.b1.b1 = true;
        c.c = true;
        debug.debug.args = ["hello"];
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
