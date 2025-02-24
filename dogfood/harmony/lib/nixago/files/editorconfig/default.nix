_: data: _: let
  output = ".editorconfig";
in {
  inherit data output;
  format = "iniWithGlobalSection";
  apply = data: {
    globalSection =
      if (builtins.hasAttr "root" data)
      then {inherit (data) root;}
      else {};
    sections = builtins.removeAttrs data ["root"];
  };
}
