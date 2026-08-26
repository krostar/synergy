{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.testers.go = with lib.types; {
      enable = lib.mkEnableOption "go test";

      package = lib.mkOption {
        type = types.functionTo types.package;
        default = {pkgs, ...}: pkgs.go;
      };

      patterns = lib.mkOption {
        type = types.listOf types.str;
        default = ["./..."];
        example = ["./..." "./cmd/..." "./pkg/..."];
      };

      diff = {
        enable = lib.mkEnableOption "a go test variant restricted to the packages affected by the git diff";

        base = lib.mkOption {
          type = types.str;
          default = "origin/main";
          example = "origin/master";
        };
      };

      verbose = lib.mkOption {
        type = types.bool;
        default = false;
      };

      race = lib.mkOption {
        type = types.bool;
        default = false;
      };

      failfast = lib.mkOption {
        type = types.bool;
        default = false;
      };

      shuffle = lib.mkOption {
        type = types.bool;
        default = false;
      };

      timeout = lib.mkOption {
        type = types.str;
        default = "10m";
        example = "30s";
      };

      count = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 5;
      };

      tags = lib.mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["integration" "e2e"];
      };

      extraFlags = lib.mkOption {
        type = types.listOf types.str;
        default = [];
        example = ["-json" "-failfast"];
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          GO_TEST_TIMEOUT_SCALE = "2";
          CGO_ENABLED = "0";
        };
      };
    };
  });
}
