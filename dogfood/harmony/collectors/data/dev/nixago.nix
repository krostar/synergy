{
  data,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.nixago = with lib.types;
      lib.mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            data = lib.mkOption {
              type = types.nullOr types.anything;
              description = "The raw configuration data";
              default = null;
            };

            engine = lib.mkOption {
              type = types.nullOr (types.functionTo types.package);
              description = "The engine to use for generating the derivation";
              default = null;
            };

            format = lib.mkOption {
              type = types.nullOr types.str;
              description = "The format of the output file";
              default = null;
            };

            hook = lib.mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  extra = mkOption {
                    type = types.nullOr (types.either types.str (types.functionTo types.str));
                    description = "Shell code to run when the file is updated";
                    default = null;
                  };
                  mode = mkOption {
                    type = types.nullOr types.str;
                    description = "The output mode to use (copy or link)";
                    default = null;
                  };
                };
              });
              description = "Additional options for controlling hook generation";
              default = null;
            };

            apply = lib.mkOption {
              type = types.nullOr (types.functionTo types.anything);
              description = "Apply this transformation to `data`";
              default = null;
            };
            output = lib.mkOption {
              type = types.str;
              description = "The relative path to link the generated file";
            };
            root = lib.mkOption {
              type = types.nullOr types.path;
              description = "The root path from which the relative path is derived";
              default = null;
            };
          };
        });

        apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
        default = {};
      };
  });
}
