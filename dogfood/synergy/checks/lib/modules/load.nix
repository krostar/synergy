{
  self,
  pkgs,
  lib,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.modules) load;
  sources = let
    removeDotNixFromKeys = self.lib.attrsets.renameKeys (v: lib.strings.removeSuffix ".nix" v);
  in
    self.lib.attrsets.liftKey "default" (
      removeDotNixFromKeys (self.lib.sources.collect ./_testdata (
        lib.lists.foldr (a: a) (self.lib.sources.read ./_testdata) (with self.lib.sources.filters; [
          regularNixFilesOnly
          (preferFilesOverDirectories "nix")
          stopAtDefaultNixFile
          dropPrefixedWithUnderscore
          dropNonDirectoryRoots
        ])
      ))
    );

  loaded =
    load {
      inherit sources;
      args = {hello = "world";};
    }
    null;
in
  testEqualContents {
    assertion = "lib.modules.load";
    actual = formatJSON "actual.json" {
      units = builtins.attrNames loaded;
      modules = builtins.mapAttrs (_: value: builtins.attrNames value) loaded;
      args = {
        names = builtins.attrNames loaded.unitb.lib.debug;
        self = loaded.unitb.lib.debug.self == loaded.unitb;
        units = loaded.unitb.lib.debug.units == loaded;
      };
      libA = builtins.attrNames loaded.unita.lib;
      libB = builtins.attrNames loaded.unitb.lib;
      libAFoo = builtins.attrNames loaded.unita.lib.foo;
    };
    expected = formatJSON "expected.json" {
      units = ["unita" "unitb"];
      modules = {
        unita = ["formatter" "lib" "packages"];
        unitb = ["lib" "packages"];
      };
      args = {
        names = [
          "hello"
          "self"
          "synergy-lib"
          "units"
        ];
        self = true;
        units = true;
      };
      libA = ["foo"];
      libB = ["debug"];
      libAFoo = ["printHello"];
    };
  }
