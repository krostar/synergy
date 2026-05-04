_: data: _: let
  output = ".editorconfig";
in {
  inherit data output;
  format = "iniWithGlobalSection";
  apply = data: {
    globalSection =
      if (builtins.hasAttr "root" data.settings)
      then {inherit (data.settings) root;}
      else {};
    sections = builtins.removeAttrs data.settings ["root"];
  };
}
