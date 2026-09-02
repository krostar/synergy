{
  data,
  lib,
  pkgs,
  units,
  ...
}:
units.harmony.lib.just.mkRecipe "testers" "test-terraform" (let
  cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.testers.terraform;
in {
  tofu-test = {
    inherit (cfg) enable;
    groups = ["terraform"];
    parameters = [''+PATHS="${lib.strings.concatStringsSep " " (builtins.map lib.strings.escapeShellArg cfg.paths)}"''];
    recipe = ''
      #!/usr/bin/env bash
      set -euo pipefail
      for path in {{ PATHS }}; do
        ${lib.meta.getExe pkgs.opentofu} -chdir="$path" init -backend=false -input=false >/dev/null
        ${lib.meta.getExe pkgs.opentofu} -chdir="$path" test${lib.strings.optionalString (builtins.length cfg.extraFlags > 0) " ${lib.strings.concatStringsSep " " cfg.extraFlags}"}
      done
    '';
  };
})
