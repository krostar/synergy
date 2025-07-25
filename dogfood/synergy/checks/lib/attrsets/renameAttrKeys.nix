{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.attrsets) renameAttrKeys;
  renamer = key: "-${key}-";
in
  testEqualContents {
    assertion = "lib.attrsets.renameAttrKeys";
    actual = formatJSON "actual.json" [
      (renameAttrKeys renamer {})
      (renameAttrKeys renamer {
        a = {
          foo = 1;
        };
        b = {
          bar = 2;
        };
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      {
        "-a-" = {"-foo-" = 1;};
        "-b-" = {"-bar-" = 2;};
      }
    ];
  }
