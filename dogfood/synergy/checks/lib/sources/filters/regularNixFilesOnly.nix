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
    assertion = "lib.sources.filters.regularFilesOnly";
    actual = formatJSON "actual.json" (filters.regularFilesOnly (read ../_testdata));

    expected = formatJSON "expected.json" {
      "foo.nix" = true;
      _unit0."foo.nix" = true;
      unita = {
        "_foo"."a.nix" = true;
        "module1.nix" = true;
        module2 = {
          "_foo.nix" = true;
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
          };
        };
        module3."e.nix" = true;
      };
    };
  }
