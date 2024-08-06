{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.sources) read collect;
in
  testEqualContents {
    assertion = "lib.sources.collect";
    actual = formatJSON "actual.json" (collect ./_testdata (read ./_testdata));

    expected = formatJSON "expected.json" {
      "foo.nix" = ./_testdata/foo.nix;
      _unit0."foo.nix" = ./_testdata/_unit0/foo.nix;
      unita = {
        "module1.nix" = ./_testdata/unita/module1.nix;
        _foo."a.nix" = ./_testdata/unita/_foo/a.nix;
        module2 = {
          "_foo.nix" = ./_testdata/unita/module2/_foo.nix;
          "default.nix" = ./_testdata/unita/module2/default.nix;
          "notdefault.nix" = ./_testdata/unita/module2/notdefault.nix;
        };
      };
      unitb = {
        module1 = {
          "a.nix" = ./_testdata/unitb/module1/a.nix;
          b = {
            c."default.nix" = ./_testdata/unitb/module1/b/c/default.nix;
            "c.nix" = ./_testdata/unitb/module1/b/c.nix;
            "notnix.json" = ./_testdata/unitb/module1/b/notnix.json;
          };
        };
        module3 = {
          "e.nix" = ./_testdata/unitb/module3/e.nix;
          "f.nix" = ./_testdata/unitb/module3/f.nix;
          "foo.notnix" = ./_testdata/unitb/module3/foo.notnix;
        };
      };
    };
  }
