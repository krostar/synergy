{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib) mustFindOneNixpkgs;
in
  testEqualContents {
    assertion = "lib.mustFindOneNixpkgs";
    actual = formatJSON "actual.json" [
      (mustFindOneNixpkgs {})
      (mustFindOneNixpkgs {nixpkgs = 42;})
      (mustFindOneNixpkgs {
        nixpkgs = 42;
        foo = "abc";
      })
      (mustFindOneNixpkgs {
        nixpkgs-foo = 42;
        notnixpkgs = 44;
      })
      (mustFindOneNixpkgs {
        nixpkgs = 42;
        nixpkgs-foo = 42;
        nixpkgs-bar = 43;
      })
    ];

    expected = formatJSON "expected.json" [
      null
      42
      42
      42
      null
    ];
  }
