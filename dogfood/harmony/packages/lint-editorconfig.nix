{
  data,
  pkgs,
  unit,
  ...
}: let
  inherit (unit.lib) nixago;
  inherit
    (nixago.make {
      inherit pkgs;
      file = nixago.files.editorconfig-checker;
      data = data.${pkgs.system}.ci.linters.lint-editorconfig;
    })
    configFile
    ;
in
  pkgs.writeShellApplication {
    name = "lint-editorconfig";

    runtimeInputs = [pkgs.editorconfig-checker];
    checkPhase = "";

    text = ''
      declare -a tolint=()
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      editorconfig-checker -config=${configFile} "''${tolint[@]}"
    '';
  }
