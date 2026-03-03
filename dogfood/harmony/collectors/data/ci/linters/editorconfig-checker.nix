{
  systems,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.editorconfig-checker = {
      enable = lib.mkEnableOption "editorconfig-checker";
      settings = with lib.types;
        lib.mkOption {
          type = types.submodule {
            options = {
              Verbose = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = "Enable verbose output.";
              };
              Debug = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = "Enable debug output.";
              };
              IgnoreDefaults = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = "Ignore default excludes.";
              };
              SpacesAftertabs = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = "Allow spaces after tabs.";
              };
              NoColor = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
                description = "Disable colored output.";
              };
              Exclude = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
                description = "List of paths to exclude.";
              };
              AllowedContentTypes = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
                description = "List of allowed content types.";
              };
              PassedFiles = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
                description = "List of files to check.";
              };
              Disable = lib.mkOption {
                type = types.nullOr (types.submodule {
                  options = {
                    EndOfLine = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable end-of-line check.";
                    };
                    Indentation = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable indentation check.";
                    };
                    IndentSize = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable indent size check.";
                    };
                    InsertFinalNewline = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable insert-final-newline check.";
                    };
                    TrimTrailingWhitespace = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable trim-trailing-whitespace check.";
                    };
                    MaxLineLength = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Disable max-line-length check.";
                    };
                  };
                });
                default = null;
              };
            };
          };
          default = {};
          apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
        };
    };
  });
}
