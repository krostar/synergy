{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.testers) testBuildFailure;
  inherit (self.lib.tests) cover;
in {
  empty = cover {
    inherit pkgs;
    unit = {
      checks = {};
    };
  };

  notStrict = cover {
    inherit pkgs;
    strict = false;
    unit = {
      foo = {a.b.c = "foo";};
      hello.world = pkgs.hello;
      checks = {
        hello.world = null;
      };
    };
  };

  strict = cover {
    inherit pkgs;
    unit = {
      foo = {a.b.c = "foo";};
      hello.world = pkgs.hello;
      checks = {
        foo.a.b.c = null;
        hello.world = null;
      };
    };
  };

  ko =
    pkgs.runCommand "cover-ko" {
      failed = testBuildFailure (cover {
        inherit pkgs;
        unit = {
          foo = {a.b.c = "foo";};
          hello.world = pkgs.hello;
          checks = {};
        };
      });
    } ''
      grep -F 'foo.a.b.c' $failed/testBuildFailure.log
      grep -F 'hello.world' $failed/testBuildFailure.log
      [[ 1 = $(cat $failed/testBuildFailure.exit) ]]
      touch $out
    '';
}
