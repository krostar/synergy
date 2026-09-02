{
  data,
  lib,
  pkgs,
  units,
  ...
}:
units.harmony.lib.just.mkRecipe "linters" "lint-terraform" (let
  ci = data.${pkgs.stdenv.hostPlatform.system}.ci;
  tofuCfg = ci.linters.tofu;
  tflintCfg = ci.linters.tflint;
  trivyCfg = ci.linters.trivy;

  mkPathsParameter = cfg: ''+PATHS="${lib.strings.concatStringsSep " " (builtins.map lib.strings.escapeShellArg cfg.paths)}"'';
in {
  tofu-fmt-check = {
    enable = tofuCfg.enable && tofuCfg.fmt.enable;
    groups = ["terraform"];
    parameters = [(mkPathsParameter tofuCfg)];
    recipe = ''
      #!/usr/bin/env bash
      set -euo pipefail
      for path in {{ PATHS }}; do
        ${lib.meta.getExe pkgs.opentofu} fmt -check -recursive -diff "$path"
      done
    '';
  };

  tofu-validate = {
    enable = tofuCfg.enable && tofuCfg.validate.enable;
    groups = ["terraform"];
    parameters = [(mkPathsParameter tofuCfg)];
    recipe = ''
      #!/usr/bin/env bash
      set -euo pipefail
      for path in {{ PATHS }}; do
        ${lib.meta.getExe pkgs.opentofu} -chdir="$path" init -backend=false -input=false >/dev/null
        ${lib.meta.getExe pkgs.opentofu} -chdir="$path" validate
      done
    '';
  };

  tflint = {
    inherit (tflintCfg) enable;
    groups = ["terraform"];
    parameters = [(mkPathsParameter tflintCfg)];
    recipe = ''
      #!/usr/bin/env bash
      set -euo pipefail
      for path in {{ PATHS }}; do
        ${lib.meta.getExe pkgs.tflint} --chdir="$path" --recursive${lib.strings.optionalString (tflintCfg.settings.config != null) " --config=${lib.strings.escapeShellArg tflintCfg.settings.config}"}
      done
    '';
  };

  trivy = {
    inherit (trivyCfg) enable;
    groups = ["terraform"];
    parameters = [(mkPathsParameter trivyCfg)];
    recipe = ''
      #!/usr/bin/env bash
      set -euo pipefail
      for path in {{ PATHS }}; do
        ${lib.meta.getExe pkgs.trivy} config --skip-version-check --exit-code ${builtins.toString trivyCfg.settings.exitCode}${lib.strings.optionalString (builtins.length trivyCfg.settings.severity > 0) " --severity ${lib.strings.concatStringsSep "," trivyCfg.settings.severity}"} "$path"
      done
    '';
  };
})
