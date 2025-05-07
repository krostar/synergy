{
  data,
  lib,
  pkgs,
  unit,
  ...
} @ args:
unit.lib.just.mkRecipe "testers" "test-go" {
  go-test = let
    cfg = data.${pkgs.system}.ci.testers.go;
  in {
    inherit (cfg) enable;
    groups = ["go"];
    parameters = lib.attrsets.mapAttrsToList (k: v: "$" + ''${k}="${lib.strings.escapeShellArg v}"'') cfg.environment;
    recipe = lib.strings.concatStringsSep " " (
      [(lib.meta.getExe (cfg.package args))]
      ++ ["test" "-timeout=${cfg.timeout}"]
      ++ (lib.lists.optional cfg.verbose "-v")
      ++ (lib.lists.optional cfg.race "-race")
      ++ (lib.lists.optional cfg.failfast "-failfast")
      ++ (lib.lists.optional cfg.shuffle "-shuffle=on")
      ++ (lib.lists.optional (cfg.count != null) "-count=${builtins.toString cfg.count}")
      ++ (lib.lists.optional (builtins.length cfg.tags > 0) "-tags='${lib.strings.concatStringsSep "," cfg.tags}'")
      ++ cfg.extraFlags
      ++ cfg.patterns
    );
  };
}
