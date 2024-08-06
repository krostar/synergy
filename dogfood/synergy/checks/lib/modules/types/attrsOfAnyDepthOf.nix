{
  self,
  pkgs,
  lib,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.modules.types) attrsOfAnyDepthOf;
in
  testEqualContents {
    assertion = "lib.modules.types.attrsOfAnyDepthOf";
    actual =
      formatJSON "actual.json"
      (lib.evalModules {
        modules = [
          {
            options.hello = lib.mkOption {
              type = attrsOfAnyDepthOf lib.types.str;
            };
          }
          {hello = {};}
          {hello = {foo.bar = "bar";};}
          {hello = {a.b.c.d.e = "bar";};}
          {hello = {world = "world";};}
        ];
      })
      .config;

    expected = formatJSON "expected.json" {
      hello = {
        a.b.c.d.e = "bar";
        foo.bar = "bar";
        world = "world";
      };
    };
  }
