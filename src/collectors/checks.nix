{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.checks = lib.mkOption {
    type = with lib.types // synergy-lib.modules.types; attrsOf (attrsOf (attrsOfAnyDepthOf (either package (listOf package))));
    default = synergy-lib.attrsets.removeEmptySets (
      let
        walk = v:
          if lib.attrsets.isDerivation v
          then v
          else if builtins.isList v
          then
            builtins.listToAttrs (
              lib.lists.imap0
              (i: v: lib.attrsets.nameValuePair (builtins.toString i) (walk v))
              v
            )
          else if builtins.isAttrs v
          then builtins.mapAttrs (_: walk) v
          else {};
      in
        walk (builtins.mapAttrs (_: m: m.checks or {}) config.synergy.result.systemized)
    );
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
