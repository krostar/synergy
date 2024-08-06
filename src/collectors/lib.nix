{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.lib = lib.mkOption {
    type = with (lib.types // synergy-lib.modules.types); attrsOf (attrsOfAnyDepthOf (functionTo raw));
    default = config.synergy.result.systemless.lib or {};
    readOnly = true;
  };

  config = let
    cfg = config.lib;
    export = config.synergy.export.lib or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.lib.systemless = true;
    flake = lib.mkIf (output != {}) {lib = output;};
  };
}
