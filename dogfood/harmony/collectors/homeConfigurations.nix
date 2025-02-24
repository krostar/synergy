_: {
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.homeConfigurations = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf raw);
    default = config.synergy.result.systemless.homeConfigurations or {};
    readOnly = true;
  };

  config = let
    cfg = config.homeConfigurations;
    export = config.synergy.export.homeConfigurations or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.homeConfigurations.systemless = true;
    flake = lib.mkIf (output != {}) {homeConfigurations = output;};
  };
}
