{
  lib,
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) collect;
in
  testEqualContents {
    assertion = "lib.modules.collect";
    actual = formatJSON "actual.json" (collect ./_testdata);
    expected = formatJSON "expected.json" {
      unita = {
        formatter = ./_testdata/unita/formatter.nix;
        lib = {
          foo = ./_testdata/unita/lib/foo.nix;
        };
        packages = ./_testdata/unita/packages.nix;
      };
      unitb = {
        lib = ./_testdata/unitb/lib/default.nix;
        packages = {
          foo = ./_testdata/unitb/packages/foo.nix;
          nix = ./_testdata/unitb/packages/nix.nix;
        };
      };
    };
  }
