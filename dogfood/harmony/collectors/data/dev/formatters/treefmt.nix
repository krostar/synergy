{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    dev.formatters.treefmt = with lib.types; {
      enable = lib.mkEnableOption "treefmt";

      package = lib.mkPackageOption pkgs "treefmt" {};

      projectRootFile = lib.mkOption {
        description = ''
          File to look for to determine the root of the project.
          Set to null to let treefmt use its native detection.
        '';
        type = nullOr str;
        default = "flake.nix";
      };

      enableDefaultExcludes = lib.mkOption {
        description = "Enable the default excludes in the treefmt configuration.";
        type = bool;
        default = true;
      };

      programs = lib.mkOption {
        type = lib.types.submodule {freeformType = with lib.types; attrsOf anything;};
        default = {};
      };

      settings = lib.mkOption {
        type = lib.types.submodule {freeformType = with lib.types; attrsOf anything;};
        default = {};
      };
    };
  });
}
