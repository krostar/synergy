{
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.sources) read;
in
  testEqualContents {
    assertion = "lib.sources.read";
    actual = formatJSON "actual.json" (read ./_testdata);

    expected = formatJSON "expected.json" {
      "foo.nix" = true;
      _unit0."foo.nix" = true;
      unita = {
        _foo."a.nix" = true;
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
            c = {"default.nix" = true;};
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
