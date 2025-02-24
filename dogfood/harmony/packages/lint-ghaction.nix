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
      if [ "$#" -ne 0 ]; then
        >&2 echo "This script takes no arguments."
        exit 1
      fi

      actionlint ${lib.strings.concatStringsSep " " (builtins.map (ignore: "-ignore ${lib.strings.escapeShellArg ignore}") config.ignore or [])}
    '';
  }
