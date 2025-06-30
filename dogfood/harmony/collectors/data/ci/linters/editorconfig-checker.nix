{
  data,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.editorconfig-checker = {
      enable = lib.mkEnableOption "alejandra";
      settings = with lib.types;
        lib.mkOption {
          type = types.submodule {
            options = {
              Verbose = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              Debug = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              IgnoreDefaults = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              SpacesAftertabs = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              NoColor = lib.mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              Exclude = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
              };
              AllowedContentTypes = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
              };
              PassedFiles = lib.mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
              };
              Disable = lib.mkOption {
                type = types.nullOr (types.submodule {
                  options = {
                    EndOfLine = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                    };
                    Indentation = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                    };
                    IndentSize = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                    };
                    InsertFinalNewline = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                    };
                    TrimTrailingWhitespace = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                    };
                    MaxLineLength = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
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
