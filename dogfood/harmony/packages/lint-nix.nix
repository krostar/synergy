{
  data,
  lib,
  pkgs,
  ...
}: let
  config = data.${pkgs.system}.ci.linters.lint-nix;
in
  pkgs.writeShellApplication {
    name = "lint-nix";

    runtimeInputs = with pkgs; [alejandra deadnix nixfmt-rfc-style statix];
    checkPhase = "";

    text = ''
      tolint=(".")
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      alejandra --check --quiet ${
        builtins.concatStringsSep " " (builtins.map (i: "--exclude ${lib.strings.escapeShellArg i}") config.alejandra.exclude)
      } "''${tolint[@]}"

      ${
        if builtins.length config.alejandra.exclude > 0
        then "nixfmt --check --strict -- " + builtins.concatStringsSep " " (builtins.map lib.strings.escapeShellArg config.alejandra.exclude)
        else "# nixfmt is only enabled when alejandra have files excluded"
      }

      statix check ${
        if builtins.length config.statix.ignore > 0
        then "--ignore ${builtins.concatStringsSep " " (builtins.map lib.strings.escapeShellArg config.statix.ignore)}"
        else ""
      } "''${tolint[@]}"

      deadnix --fail --hidden ${
        if builtins.length config.deadnix.exclude > 0
        then "--exclude ${builtins.concatStringsSep " " (builtins.map lib.strings.escapeShellArg config.deadnix.exclude)}"
        else ""
      } -- "''${tolint[@]}"
    '';
  }
