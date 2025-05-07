{
  data,
  lib,
  pkgs,
  unit,
  ...
}:
unit.lib.just.mkRecipe "linters" "lint-github" {
  _actionlint = let
    cfg = data.${pkgs.system}.ci.linters.actionlint;
  in {
    inherit (cfg) enable;
    attributes = ["positional-arguments"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.actionlint} ${lib.strings.concatStringsSep " " (builtins.map (ignore: "-ignore ${lib.strings.escapeShellArg ignore}") cfg.settings.ignore or [])} "$@"
    '';
  };
}
