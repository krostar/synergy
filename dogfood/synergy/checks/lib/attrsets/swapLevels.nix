{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.attrsets) swapLevels;
in
  testEqualContents {
    assertion = "lib.attrsets.swapLevels";
    actual = formatJSON "actual.json" [
      (swapLevels {})
      (swapLevels {a = {};})
      (swapLevels {a.b.c = 1;})
      (swapLevels {
        a.b = "hello";
        c.b = "world";
        b.a = "nothello";
        b.c = "notworld";
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      {}
      {b.a.c = 1;}
      {
        a.b = "nothello";
        b = {
          a = "hello";
          c = "world";
        };
        c.b = "notworld";
      }
    ];
  }
