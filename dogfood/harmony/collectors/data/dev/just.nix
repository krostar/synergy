{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.just = lib.mkOption {
      type = with lib.types;
        types.submodule {
          options = {
            module = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Optional module name for the justfile.";
            };

            imports = lib.mkOption {
              type = types.listOf types.str;
              default = [];
              description = "List of justfiles to import.";
            };

            settings = lib.mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = "Just settings (like shell, positional-arguments, etc.).";
            };

            pre-recipes = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Raw content to include before recipes.";
            };

            default = lib.mkOption {
              type = types.nullOr types.str;
              default = "just --list";
              description = "Optional default recipe.";
            };

            recipes = lib.mkOption {
              type = types.attrsOf (types.submodule {
                options = {
                  enable = lib.mkEnableOption "whether to enable this recipe";

                  aliases = lib.mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Aliases for the recipe.";
                  };

                  documentation = lib.mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "Documentation comment for the recipe.";
                  };

                  comment = lib.mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = "General comment for the recipe, as opposed to documentation.";
                  };

                  attributes = lib.mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Attributes like 'private', 'no-cd', etc.";
                  };

                  groups = lib.mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Groups this recipe belongs to.";
                  };

                  parameters = lib.mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Parameters for the recipe including default values.";
                  };

                  dependencies = lib.mkOption {
                    type = types.listOf types.str;
                    default = [];
                    description = "Dependencies for this recipe.";
                  };

                  recipe = lib.mkOption {
                    type = types.nullOr types.str;
                    description = "The actual recipe commands.";
                    default = null;
                  };
                };
              });
              default = {};
              description = "List of recipes.";
            };

            post-recipes = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Raw content to include after recipes.";
            };
          };
        };
      default = {};
    };
  });
}
