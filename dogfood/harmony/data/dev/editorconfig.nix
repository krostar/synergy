let
  allUnset = {
    charset = "unset";
    end_of_line = "unset";
    indent_size = "unset";
    indent_style = "unset";
    insert_final_newline = "unset";
    trim_trailing_whitespace = "unset";
  };
  indentWithTab = {
    indent_size = "tab";
    indent_style = "tab";
  };
in {
  root = true;

  "*" = {
    charset = "utf-8";
    end_of_line = "lf";
    indent_size = 2;
    indent_style = "space";
    insert_final_newline = true;
    tab_width = 4;
    trim_trailing_whitespace = true;
  };

  "go.mod" = indentWithTab;
  "*.go" = indentWithTab;
  "*.cue" = indentWithTab;

  "/LICENSE" = allUnset;
  "secrets/**" = allUnset;
}
