{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.flake-checker = with lib.types; {
      enable = lib.mkEnableOption "flake-checker";

      package = lib.mkOption {
        type = types.functionTo types.package;
        default = {
          flake,
          pkgs,
          ...
        }:
          flake.inputs.flake-checker.packages.${pkgs.system}.default;
        description = "The flake-checker package to use.";
      };

      flakeLockPath = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The path to the flake.lock file to check.";
      };

      noTelemetry = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Don't send aggregate sums of each issue type.";
      };

      checkOutdated = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Check for outdated Nixpkgs inputs.";
      };

      checkOwner = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Check that Nixpkgs inputs have \"NixOS\" as the GitHub owner.";
      };

      checkSupported = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Check that Git refs for Nixpkgs inputs are supported.";
      };

      ignoreMissingFlakeLock = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Ignore a missing flake.lock file.";
      };

      failMode = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Fail with an exit code of 1 if any issues are encountered.";
      };

      nixpkgsKeys = lib.mkOption {
        type = types.listOf types.str;
        default = ["nixpkgs"];
        description = "Nixpkgs input keys as a list.";
      };

      markdownSummary = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Display Markdown summary (in GitHub Actions).";
      };

      condition = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The Common Expression Language (CEL) policy to apply to each Nixpkgs input.";
      };
    };
  });
}
