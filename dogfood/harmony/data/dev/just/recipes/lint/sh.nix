{
  data,
  lib,
  pkgs,
  unit,
  ...
}:
unit.lib.just.mkRecipe "linters" "lint-sh" {
  bashate = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.bashate;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.bashate} ${
        if builtins.length (cfg.settings.ignore or []) > 0
        then "--ignore ${builtins.concatStringsSep "," (builtins.map lib.strings.escapeShellArg cfg.settings.ignore)}"
        else ""
      } {{ if FILES == "" { (`${pkgs.findutils}/bin/find . -type f \( ${
        builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
      } \) -print0 | xargs -0 printf "%q "` + ${
        if builtins.length (cfg.settings.include.files or []) > 0
        then ''"'' + builtins.concatStringsSep " " cfg.settings.include.files + ''"''
        else ""
      }) } else { FILES } }}
    '';
  };

  shellcheck = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.shellcheck;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.shellcheck} {{ if FILES == "" { (`${pkgs.findutils}/bin/find . -type f \( ${
        builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
      } \) -print0 | xargs -0 printf "%q "` + ${
        if builtins.length (cfg.settings.include.files or []) > 0
        then ''"'' + builtins.concatStringsSep " " cfg.settings.include.files + ''"''
        else ""
      }) } else { FILES } }}
    '';
  };

  shellharden = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.shellharden;
  in {
    inherit (cfg) enable;
    groups = ["sh"];
    parameters = ["*FILES"];
    recipe =
      lib.meta.getExe (pkgs.writeShellApplication {
        name = "shellharden";

        runtimeInputs = [pkgs.shellharden];
        checkPhase = "";

        text = ''
          failed=0

          if [[ $# -eq 0 ]]; then
            mapfile -t files < <( ${pkgs.findutils}/bin/find . -type f \( ${
            builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") (cfg.settings.include.find or []))
          } \) )
            ${
            if builtins.length (cfg.settings.include.files or []) > 0
            then "files+=(" + (builtins.concatStringsSep " " cfg.settings.include.files) + ")"
            else ""
          }
          else
            files=("$@")
          fi

          for file in "''${files[@]}"
          do
            if ! ${lib.meta.getExe pkgs.shellharden} --check "$file"; then
              echo "Error in file: $file"
              ${lib.meta.getExe pkgs.shellharden} --suggest "$file"
              failed=1
            fi
          done

          exit "$failed"
        '';
      })
      + " {{ FILES }}";
  };
}
