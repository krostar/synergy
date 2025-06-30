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
      not-squashed = autoimport {
        source = ./modules/_testdata/test-import;
        args.hello = "world";
      };

      squashed = autoimport {
        source = ./modules/_testdata/test-import;
        args.hello = "world";
        squash = true;
      };
    };
    expected = formatJSON "expected.json" {
      not-squashed = {
        a.a = true;
        b.b1.b1 = true;
        c.c = true;
        debug.debug.args = ["hello"];
      };

      squashed = {
        a = true;
        b1 = true;
        c = true;
        debug.args = ["hello"];
      };
    };
  }
