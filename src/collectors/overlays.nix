{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.overlays = lib.mkOption {
    type = with (lib.types // synergy-lib.modules.types); attrsOf (attrsOfAnyDepthOf (functionTo (functionTo (attrsOf raw))));
    default = config.synergy.result.systemless.overlays or {};
    readOnly = true;
  };

  config = let
    cfg = config.overlays;
    export = config.synergy.export.overlays or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.overlays.systemless = true;
    flake = lib.mkIf (output != {}) {lib = output;};
  };
}
