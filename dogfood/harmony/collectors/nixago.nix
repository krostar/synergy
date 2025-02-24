_: {
  config,
  lib,
  ...
}: {
  options.nixago = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (attrsOf raw));
    default = lib.attrsets.filterAttrs (_: v: v != {}) (builtins.mapAttrs (_: m: m.nixago or {}) config.synergy.result.systemized);
    readOnly = true;
  };

  config = {
    synergy.collected.nixago.systemized = true;
  };
}
