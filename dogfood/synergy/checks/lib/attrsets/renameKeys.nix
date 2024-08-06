{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.attrsets) renameKeys;
  renamer = key: "-${key}-";
in
  testEqualContents {
    assertion = "lib.attrsets.renameKeys";
    actual = formatJSON "actual.json" [
      (renameKeys renamer {})
      (renameKeys renamer {
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
