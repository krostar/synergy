{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.attrsets) removeAttrKeyRecursively;
in
  testEqualContents {
    assertion = "lib.attrsets.removeAttrKeyRecursively";
    actual = formatJSON "actual.json" [
      (removeAttrKeyRecursively "removeme" {})
      (removeAttrKeyRecursively "removeme" {
        a = 1;
        removeme = 2;
      })

      (removeAttrKeyRecursively "removeme" {
        a = 1;
        removeme = {
          a = 2;
        };
      })

      (removeAttrKeyRecursively "removeme" {
        a = 1;
        b.removeme = {};
      })

      (removeAttrKeyRecursively "removeme" {
        a = 1;
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      {a = 1;}
      {a = 1;}
      {
        a = 1;
        b = {};
      }
      {a = 1;}
    ];
  }
