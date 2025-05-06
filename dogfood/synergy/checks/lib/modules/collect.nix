{
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
      test-import = {
        a = ./_testdata/test-import/a.nix;
        b.b1 = ./_testdata/test-import/b/b1.nix;
        c = ./_testdata/test-import/c/default.nix;
        debug = ./_testdata/test-import/debug.nix;
      };
      test-load = {
        unita = {
          formatter = ./_testdata/test-load/unita/formatter.nix;
          lib = {
            foo = ./_testdata/test-load/unita/lib/foo.nix;
          };
          packages = ./_testdata/test-load/unita/packages.nix;
        };
        unitb = {
          lib = ./_testdata/test-load/unitb/lib/default.nix;
          packages = {
            foo = ./_testdata/test-load/unitb/packages/foo.nix;
            nix = ./_testdata/test-load/unitb/packages/nix.nix;
          };
        };
      };
    };
  }
