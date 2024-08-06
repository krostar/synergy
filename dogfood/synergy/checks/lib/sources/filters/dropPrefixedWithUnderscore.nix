{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.sources) read filters;
in
  testEqualContents {
    assertion = "lib.sources.filters.dropPrefixedWithUnderscore";
    actual = formatJSON "actual.json" (filters.dropPrefixedWithUnderscore (read ../_testdata));

    expected = formatJSON "expected.json" {
      "foo.nix" = true;
      unita = {
        "module1.nix" = true;
        module2 = {
          "default.nix" = true;
          "notdefault.nix" = true;
        };
      };
      unitb = {
        module1 = {
          "a.nix" = true;
          b = {
            c."default.nix" = true;
            "c.nix" = true;
            "notnix.json" = false;
          };
        };
        module3 = {
          "e.nix" = true;
          "f.nix" = false;
          "foo.notnix" = false;
        };
      };
    };
  }
