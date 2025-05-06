{
  data,
  lib,
  pkgs,
  unit,
  ...
}:
unit.lib.just.mkRecipe "linters" "lint-sh" {
  bashate = let
    cfg = data.${pkgs.system}.ci.linters.bashate;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    attributes = ["positional-arguments"];
    parameters = [''+FILES=(`${pkgs.findutils}/bin/find . -type f \( ${
        builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
      } \) -print0 | xargs -0 printf "%q "` + ${
        if builtins.length (cfg.settings.include.files or []) > 0
        then ''"'' + builtins.concatStringsSep " " cfg.settings.include.files + ''"''
        else ""
      })''];
    recipe = ''
      ${lib.meta.getExe pkgs.bashate} ${
        if builtins.length (cfg.settings.ignore or []) > 0
        then "--ignore ${builtins.concatStringsSep "," (builtins.map lib.strings.escapeShellArg cfg.settings.ignore)}"
        else ""
      } $@
    '';
  };

  shellcheck = let
    cfg = data.${pkgs.system}.ci.linters.shellcheck;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    attributes = ["positional-arguments"];
    parameters = [''+FILES=(`${pkgs.findutils}/bin/find . -type f \( ${
        builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
      } \) -print0 | xargs -0 printf "%q "` + ${
        if builtins.length (cfg.settings.include.files or []) > 0
        then ''"'' + builtins.concatStringsSep " " cfg.settings.include.files + ''"''
        else ""
      })''];
    recipe = ''
      ${lib.meta.getExe pkgs.shellcheck} $@
    '';
  };

  shellharden = let
    cfg = data.${pkgs.system}.ci.linters.shellharden;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    attributes = ["positional-arguments"];
    parameters = [''+FILES=(`${pkgs.findutils}/bin/find . -type f \( ${
        builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
      } \) -print0 | xargs -0 printf "%q "` + ${
        if builtins.length (cfg.settings.include.files or []) > 0
        then ''"'' + builtins.concatStringsSep " " cfg.settings.include.files + ''"''
        else ""
      })''];
    recipe = lib.meta.getExe (pkgs.writeShellApplication {
      name = "shellharden";

      runtimeInputs = [pkgs.shellharden];
      checkPhase = "";

      text = ''
        failed=0

        while IFS= read -r file; do
          if ! ${lib.meta.getExe pkgs.shellharden} --check "$file"; then
            echo "Error in file: $file"
            ${lib.meta.getExe pkgs.shellharden} --suggest "$file"
            failed=1
          fi
        done <<< "$@"

        exit "$failed"
      '';
    });
  };
}
