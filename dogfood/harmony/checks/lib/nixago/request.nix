/*
Unit tests for the request normalization (_core/request.nix): defaults,
format inference, functor stripping, hook.extra list support, and rejection
of malformed requests.
*/
{
  pkgs,
  lib,
  ...
}: let
  normalize = import ../../../lib/nixago/_core/request.nix {inherit lib;};

  formatJSON = (pkgs.formats.json {}).generate;

  # `apply` is a function and cannot be serialized
  serialize = request: builtins.removeAttrs request ["apply"];

  fails = request: !(builtins.tryEval (normalize request)).success;
in
  pkgs.testers.testEqualContents {
    assertion = "lib.nixago request normalization";
    actual = formatJSON "actual.json" {
      defaults = serialize (normalize {
        data.a = 1;
        output = "sub/config.yaml";
      });

      explicit = serialize (normalize {
        __functor = _: throw "__functor must be stripped from requests";
        data = 2;
        output = "x.json";
        format = "toml";
        root = "/some/root";
        hook = {
          extra = ["echo a" "echo b"];
          mode = "copy";
        };
      });

      failures = {
        missing-data = fails {output = "x.json";};
        missing-output = fails {data = 1;};
        non-string-output = fails {
          data = 1;
          output = 42;
        };
        invalid-hook-mode = fails {
          data = 1;
          output = "x.json";
          hook.mode = "symlink";
        };
      };
    };
    expected = formatJSON "expected.json" {
      defaults = {
        data.a = 1;
        output = "sub/config.yaml";
        format = "yaml";
        hook = {
          extra = "";
          mode = "link";
        };
      };

      explicit = {
        data = 2;
        output = "x.json";
        format = "toml";
        root = "/some/root";
        hook = {
          extra = "echo a\necho b";
          mode = "copy";
        };
      };

      failures = {
        missing-data = true;
        missing-output = true;
        non-string-output = true;
        invalid-hook-mode = true;
      };
    };
  }
