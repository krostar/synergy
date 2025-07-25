{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.attrsets) liftAll;
in
  testEqualContents {
    assertion = "lib.attrsets.liftAll";
    actual = formatJSON "actual.json" [
      (liftAll "-" {})
      (liftAll "-" {
        a.b.c = 4;
        a.z = 3;
      })
      (liftAll "-" {a.z = pkgs.hello;})
    ];

    expected = formatJSON "expected.json" [
      {}
      {
        a-b-c = 4;
        a-z = 3;
      }
      {a-z = pkgs.hello;}
    ];
  }
