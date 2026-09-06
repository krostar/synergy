_: {
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.systemConfigurations = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf raw);
    default = config.synergy.result.systemless.systemConfigurations or {};
    readOnly = true;
  };

  config = let
    cfg = config.systemConfigurations;
    export = config.synergy.export.systemConfigurations or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.systemConfigurations.systemless = true;
    flake = lib.mkIf (output != {}) {systemConfigs = output;};
  };
}
