{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.packages = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (attrsOf package));
    default = lib.attrsets.filterAttrs (_: v: v != {}) (builtins.mapAttrs (_: m: m.packages or {}) config.synergy.result.systemized);
    readOnly = true;
  };

  config = let
    cfg = config.packages;
    export = config.synergy.export.packages or (builtins.mapAttrs (_: m: synergy-lib.attrsets.liftChildren "-" m));
    output = export cfg;
  in {
    synergy.collected.packages.systemized = true;
    flake = lib.mkIf (output != {}) {packages = output;};
  };
}
