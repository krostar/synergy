{
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.sources) read filters;
in
  testEqualContents {
    assertion = "lib.sources.filters.stopAtDefaultNixFile";
    actual = formatJSON "actual.json" (filters.stopAtDefaultNixFile (read ../_testdata));

    expected = formatJSON "expected.json" {
      "foo.nix" = true;
      _unit0."foo.nix" = true;
      unita = {
        "_foo"."a.nix" = true;
        "module1.nix" = true;
        module2."default.nix" = true;
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
