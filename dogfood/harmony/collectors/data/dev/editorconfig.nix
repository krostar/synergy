{
  data,
  unit,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.editorconfig = with lib.types;
      lib.mkOption {
        type = types.attrsOf (types.either types.bool (types.submodule {
          options = {
            charset = lib.mkOption {
              type = types.nullOr (types.enum ["unset" "utf-8" "utf-16be" "utf-16le" "latin1"]);
              default = null;
              description = "Character set of the file";
            };

            end_of_line = lib.mkOption {
              type = types.nullOr (types.enum ["unset" "lf" "cr" "crlf"]);
              default = null;
              description = "Line ending style";
            };

            indent_size = lib.mkOption {
              type = types.nullOr (types.either (types.enum ["unset" "tab"]) types.ints.positive);
              default = null;
              description = "Size of indentation in spaces";
            };

            indent_style = lib.mkOption {
              type = types.nullOr (types.enum ["unset" "space" "tab"]);
              default = null;
              description = "Indentation style";
            };

            insert_final_newline = lib.mkOption {
              type = types.nullOr (types.either (types.enum ["unset"]) types.bool);
              default = null;
              description = "Whether to insert a final newline";
            };

            max_line_length = lib.mkOption {
              type = types.nullOr (types.either (types.enum ["unset"]) types.ints.positive);
              default = null;
              description = "Maximum allowed line length";
            };

            tab_width = lib.mkOption {
              type = types.nullOr (types.either (types.enum ["unset"]) types.ints.positive);
              default = null;
              description = "Width of a tab character";
            };

            trim_trailing_whitespace = lib.mkOption {
              type = types.nullOr (types.either (types.enum ["unset"]) types.bool);
              default = null;
              description = "Whether to trim trailing whitespace";
            };
          };
        }));

        description = "Editor configuration settings";
        default = {};
        apply = unit.lib.attrsets.removeNullAttrs;
      };
  });
}
