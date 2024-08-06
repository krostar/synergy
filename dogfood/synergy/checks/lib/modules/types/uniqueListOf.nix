{
  lib,
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.modules.types) uniqueListOf;
in
  testEqualContents {
    assertion = "lib.modules.types.uniqueListOf";
    actual =
      formatJSON "actual.json"
      (lib.evalModules {
        modules = [
          {
            options.hello = lib.mkOption {
              type = uniqueListOf lib.types.str;
            };
          }
          {hello = ["d"];}
          {hello = ["a" "b" "c"];}
          {hello = [];}
          {hello = ["b" "c" "a"];}
        ];
      })
      .config;

    expected = formatJSON "expected.json" {
      hello = ["a" "b" "c" "d"];
    };
  }
