{
  flake,
  pkgs,
  unit,
  ...
}: let
  formatJSON = (pkgs.formats.json {}).generate;
  inherit (pkgs.testers) testEqualContents;
  inherit (unit.lib.modules) eval importApply;

  evaled = eval {
    src = ./_testdata/test-load;
    inputs = {
      inherit (flake.inputs) nixpkgs;
      self = {inherit (flake) outPath narHash;};
    };
  };
in
  testEqualContents {
    assertion = "lib.modules.importApply";

    actual = formatJSON "actual.json" {
      packages = let
        extended =
          (evaled.extendModules {
            modules = [
              ({
                lib,
                synergy-sources,
                ...
              }: {
                options.bar = lib.mkOption {type = lib.types.anything;};
                imports = importApply synergy-sources "packages" true (result: {config.bar = result;});
              })
            ];
          }).config.bar;
      in
        builtins.attrNames (builtins.head (builtins.attrValues extended));

      lib = let
        extended =
          (evaled.extendModules {
            modules = [
              ({
                lib,
                synergy-sources,
                ...
              }: {
                options.bar = lib.mkOption {type = lib.types.anything;};
                imports = importApply synergy-sources "lib" false (result: {config.bar = result;});
              })
            ];
          }).config.bar;
      in {
        foo = builtins.attrNames extended.foo;
        debug = builtins.attrNames extended.debug;
      };

      nonexisting =
        (evaled.extendModules {
          modules = [
            ({
              lib,
              synergy-sources,
              ...
            }: {
              options.foo = lib.mkOption {
                type = lib.types.anything;
                default = null;
              };
              imports = importApply synergy-sources "nonexisting" false (result: {config.foo = result;});
            })
          ];
        }).config.foo;
    };

    expected = formatJSON "expected.json" {
      packages = [
        "foo"
        "hello"
        "nginx"
        "nix"
      ];
      lib = {
        debug = [
          "data"
          "deps"
          "flake"
          "lib"
          "results"
          "synergy-lib"
          "unit"
          "units"
        ];
        foo = ["printHello"];
      };
      nonexisting = null;
    };
  }
