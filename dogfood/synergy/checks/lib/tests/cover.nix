{
  pkgs,
  unit,
  ...
}: let
  inherit (pkgs.testers) testBuildFailure;
  inherit (unit.lib.tests) cover;
in [
  (cover {
    inherit pkgs;
    unit = {
      checks = {};
    };
  })

  (cover {
    inherit pkgs;
    strict = false;
    unit = {
      foo = {a.b.c = "foo";};
      hello.world = pkgs.hello;
      checks = {
        hello.world = null;
      };
    };
  })

  (cover {
    inherit pkgs;
    unit = {
      foo = {a.b.c = "foo";};
      hello.world = pkgs.hello;
      checks = {
        foo.a.b.c = null;
        hello.world = null;
      };
    };
  })

  (pkgs.runCommand "cover-ko" {
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
    '')
]
