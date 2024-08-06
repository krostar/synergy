{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.attrsets) liftChildren;
in
  testEqualContents {
    assertion = "lib.attrsets.liftChildren";
    actual = formatJSON "actual.json" [
      (liftChildren "-" {})
      (liftChildren "-" {
        p1 = {
          a = 1;
          b = 2;
          c = 3;
        };
        p2 = {b = 3;};
      })
      (liftChildren "-" {
        p1 = {
          p2 = {p3 = 42;};
        };
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      {
        p1-a = 1;
        p1-b = 2;
        p1-c = 3;
        p2-b = 3;
      }
      {
        p1-p2 = {
          p3 = 42;
        };
      }
    ];
  }
