{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.attrsets) liftKey;
in
  testEqualContents {
    assertion = "lib.attrsets.liftKey";
    actual = formatJSON "actual.json" [
      (liftKey "default" {})

      (liftKey "default" {
        default = 1;
      })

      (liftKey "default" {
        default = {default = 1;};
      })

      (liftKey "default" {
        default = {default = 1;};
        notdefault = 2;
      })

      (liftKey "default" {
        default = {notdefault = 1;};
        notdefault = 2;
        other = 3;
      })

      (liftKey "default" {
        default = {
          notdefault = 1;
          default = {notdefault = 2;};
        };
        notdefault = 3;
        other = 4;
      })
    ];

    expected = formatJSON "expected.json" [
      {}
      1
      1
      1
      {
        notdefault = 1;
        other = 3;
      }
      {
        notdefault = 2;
        other = 4;
      }
    ];
  }
