{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.attrsets) removeEmptySets;
in
  testEqualContents {
    assertion = "lib.attrsets.removeEmptySets";
    actual = formatJSON "actual.json" [
      (removeEmptySets {})
      (removeEmptySets {
        a = {
          b = {
            c = {};
          };
        };
      })

      (removeEmptySets {
        a = 1;
      })

      (removeEmptySets {
        a = 1;
        b = {};
      })

      (removeEmptySets {
        a = 1;
        b = {
          c = 1;
          d = {};
        };
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      {}
      {a = 1;}
      {a = 1;}
      {
        a = 1;
        b = {c = 1;};
      }
    ];
  }
