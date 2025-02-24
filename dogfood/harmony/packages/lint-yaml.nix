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
      file = nixago.files.yamllint;
      data = data.${pkgs.system}.ci.linters.lint-yaml.yamllint;
    })
    configFile
    ;
in
  pkgs.writeShellApplication {
    name = "lint-yaml";

    runtimeInputs = [pkgs.yamllint];
    checkPhase = "";

    text = ''
      tolint=(".")
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      yamllint -c ${configFile} "''${tolint[@]}"
    '';
  }
