{
  data,
  lib,
  pkgs,
  ...
}: let
  config = data.${pkgs.system}.ci.linters.lint-sh;
in
  pkgs.writeShellApplication {
    name = "lint-sh";

    runtimeInputs = with pkgs; [bashate shellcheck shellharden];
    checkPhase = "";

    text = ''
      get_files_to_check() {
        local -a files

        files=(${builtins.concatStringsSep " " config.additionalFiles})
        local -a found; readarray -d "" -t found < <(find . -type f \( ${builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") config.findFiles)} \) -print0)
        files+=("''${found[@]}")
        files+=("$0")

        printf '%s\0' "''${files[@]}"
      }

      run_linting_tools() {
        local -a -r files=("$@")

        set -o xtrace # Print commands and their arguments as they are executed.
        shellcheck "''${files[@]}"
        bashate --ignore E003,E006 "''${files[@]}"
        shellharden --check "''${files[@]}" || shellharden --suggest "''${files[@]}"
      }

      main() {
        local -a files; readarray -d "" -t files < <(get_files_to_check)
        run_linting_tools "''${files[@]}"
      }

      if [ "$#" -ne 0 ]; then
        >&2 echo "This script takes no arguments."
        exit 1
      fi

      main
    '';
  }
