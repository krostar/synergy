{
  synergy-lib,
  systems,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.statix = {
      enable = lib.mkEnableOption "statix";
      settings = lib.mkOption {
        type = lib.types.submodule {
          options = let
            linterNames = [
              "bool_comparison"
              "empty_let_in"
              "manual_inherit"
              "manual_inherit_from"
              "legacy_let_syntax"
              "collapsible_let_in"
              "eta_reduction"
              "useless_parens"
              "empty_pattern"
              "redundant_pattern_bind"
              "unquoted_uri"
              "deprecated_is_null"
              "empty_inherit"
              "faster_groupby"
              "faster_zipattrswith"
              "deprecated_to_path"
              "bool_simplification"
              "useless_has_attr"
              "repeated_keys"
              "empty_list_concat"
            ];
          in {
            disabled = lib.mkOption {
              type = lib.types.nullOr (synergy-lib.modules.types.uniqueListOf (lib.types.enum linterNames));
              default = null;
              description = "List of linters to disable.";
            };

            nix_version = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Nix version to use for compatibility checks.";
            };

            ignore = lib.mkOption {
              type = synergy-lib.modules.types.uniqueListOf lib.types.str;
              default = [];
              description = "List of paths to ignore.";
            };
          };
        };
        default = {};
        apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
      };
    };
  });
}
