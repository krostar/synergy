{
  unit,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.commitlint = {
      enable = lib.mkEnableOption "commitlint";
      settings = lib.mkOption {
        type = lib.types.submodule {
          options = {
            extends = lib.mkOption {
              type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
              default = null;
              example = lib.literalExpression ''[ "@commitlint/config-conventional" ]'';
              description = "Shareable configuration(s) to extend; either a single string or a list of strings.";
            };

            plugins = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = null;
              example = lib.literalExpression ''[ "commitlint-plugin-jira-rules" ]'';
              description = "List of plugins to load.";
            };

            rules = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf lib.types.raw);
              default = null;
              example = lib.literalExpression ''
                {
                  "body-leading-blank" = [ 1 "always" ];
                  "type-enum" = [ 2 "always" [ "build" "chore" "ci" "docs" "feat" "fix" "perf" "refactor" "revert" "style" "test" ] ];
                }
              '';
              description = ''
                Rules to apply. The value is an attribute set where keys are rule names
                and values are lists in the format [Level, Applicable, Value].
                - Level: 0 (disable), 1 (warn), 2 (error)
                - Applicable: "always" or "never"
                - Value: The expected value for the rule (string, int, list of strings, etc.)
              '';
            };

            parserPreset = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.either lib.types.str (
                  lib.types.submodule {
                    options = {
                      name = lib.mkOption {
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                      path = lib.mkOption {
                        type = lib.types.nullOr lib.types.str;
                        default = null;
                      };
                    };
                  }
                )
              );
              default = null;
              example = "conventional-changelog-atom";
              description = "The parser preset to use; either a preset name string or an object with name/path fields.";
            };

            formatter = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "@commitlint/format";
              description = "The formatter to use for the output.";
            };

            helpUrl = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "URL to display for help with format errors.";
            };

            defaultIgnores = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
              description = "If `false`, default commit messages (merge, revert, etc.) are not ignored.";
            };

            ignores = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = null;
              example = lib.literalExpression ''[ "(WIP)" ]'';
              description = "List of strings or regex patterns. Matching commits will be ignored.";
            };
          };
        };
        apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
      };
    };
  });
}
