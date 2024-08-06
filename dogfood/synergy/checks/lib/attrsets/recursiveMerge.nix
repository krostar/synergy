{
  lib,
  pkgs,
  self,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (self.lib.attrsets) recursiveMerge;
in
  testEqualContents {
    assertion = "lib.attrsets.recursiveMerge";
    actual = formatJSON "actual.json" [
      (recursiveMerge [])
      (recursiveMerge [{} {}])
      (recursiveMerge [{a = 1;} {a = 2;}])
      (recursiveMerge [{a = [1];} {a = [2];}])
      (recursiveMerge [{a = [1];} {a = 2;}])
      (recursiveMerge [{a = {b = 2;};} {a = 2;}])

      (recursiveMerge [
        {a = 1;}
        {b = 2;}
        {c = [3];}
        {c = [4];}
        {d = {a = 1;};}
        {d = {a = 5;};}
        {d = {b = 6;};}
      ])

      (recursiveMerge [
        {
          a = lib.mkDefault {a = 1;};
          b = {c = 4;};
        }
        {
          a = lib.mkForce {b = 2;};
          b = {d = 5;};
        }
      ])

      (recursiveMerge [
        {inherit (pkgs) hello;}
        {hello = 42;}
      ])

      (recursiveMerge [
        {inherit (pkgs) hello;}
        {hello = pkgs.nginx;}
      ])
    ];

    expected = formatJSON "expected.json" [
      {}
      {}
      {a = 2;}
      {a = [1 2];}
      {a = 2;}
      {a = 2;}
      {
        a = 1;
        b = 2;
        c = [3 4];
        d = {
          a = 5;
          b = 6;
        };
      }
      {
        a = {
          _type = "merge";
          contents = [
            {
              _type = "override";
              content = {
                a = 1;
              };
              priority = 1000;
            }
            {
              _type = "override";
              content = {
                b = 2;
              };
              priority = 50;
            }
          ];
        };
        b = {
          c = 4;
          d = 5;
        };
      }
      {hello = 42;}
      {hello = pkgs.nginx;}
    ];
  }
