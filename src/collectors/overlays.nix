{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.overlays = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (functionTo (functionTo (attrsOf raw))));
    default = let
      overlays = config.synergy.result.systemless.overlays or {};
    in
      builtins.mapAttrs (_: overlay:
        if builtins.isFunction overlay
        then {default = overlay;}
        else overlay)
      overlays;
    readOnly = true;
  };

  config = let
    cfg = config.overlays;
    export = config.synergy.export.overlays or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.overlays.systemless = true;
    flake = lib.mkIf (output != {}) {overlays = output;};
  };
}
