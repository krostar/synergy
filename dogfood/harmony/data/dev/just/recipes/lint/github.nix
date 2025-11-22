{
  data,
  lib,
  pkgs,
  unit,
  ...
}:
unit.lib.just.mkRecipe "linters" "lint-github" {
  actionlint = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.actionlint;
  in {
    inherit (cfg) enable;
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.actionlint} ${lib.strings.concatStringsSep " " (builtins.map (ignore: "-ignore ${lib.strings.escapeShellArg ignore}") cfg.settings.ignore or [])} {{ FILES }}
    '';
  };
}
