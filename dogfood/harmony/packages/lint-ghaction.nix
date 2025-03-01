{
  data,
  lib,
  pkgs,
  ...
}: let
  config = data.${pkgs.system}.ci.linters.lint-ghaction;
in
  pkgs.writeShellApplication {
    name = "lint-ghaction";

    runtimeInputs = with pkgs; [actionlint shellcheck];
    checkPhase = "";

    text = ''
      declare -a tolint=()
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      actionlint ${lib.strings.concatStringsSep " " (builtins.map (ignore: "-ignore ${lib.strings.escapeShellArg ignore}") config.ignore or [])} "''${tolint[@]}"
    '';
  }
