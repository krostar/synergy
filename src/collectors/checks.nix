{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.checks = lib.mkOption {
    type = with lib.types // synergy-lib.modules.types; attrsOf (attrsOf (attrsOfAnyDepthOf package));
    default = lib.attrsets.filterAttrs (_: v: v != {}) (builtins.mapAttrs (_: m: m.checks or {}) config.synergy.result.systemized);
    readOnly = true;
  };

  config = let
    cfg = config.checks;
    export = config.synergy.export.checks or (builtins.mapAttrs (_: m: synergy-lib.attrsets.liftAll "-" m));
    output = export cfg;
  in {
    synergy.collected.checks.systemized = true;
    flake = lib.mkIf (output != {}) {checks = output;};
  };
}
