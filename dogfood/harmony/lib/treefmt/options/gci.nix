_: {
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.gci;
in {
  meta.maintainers = ["krostar"];

  options.programs.gci = {
    enable = lib.mkEnableOption "gci";
    package = lib.mkPackageOption pkgs "gci" {};
    order = lib.mkOption {
      type = lib.types.listOf (
        lib.types.either (lib.types.strMatching "Prefix[(].+[)]") (lib.types.enum [
          "alias"
          "blank"
          "default"
          "dot"
          "localmodule"
          "standard"
        ])
      );
      default = ["standard" "default"];
      description = lib.mdDoc ''
        standard: Go official imports, like "fmt"
        Prefix(*): Custom section, use full and the longest match (match full string first, if multiple matches, use the longest one)
        default: All rest import blocks
        blank: Put blank imports together in a separate group
        dot: Put dot imports together in a separate group
        alias: Put alias imports together in a separate group
        localmodule: Put imports from local packages in a separate group
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.gci = {
      command = lib.getExe' cfg.package "gci";
      options = ["write" "--custom-order"] ++ lib.lists.flatten (builtins.map (o: ["--section" o]) cfg.order);
      includes = ["*.go"];
      excludes = ["vendor/*"];
    };
  };
}
