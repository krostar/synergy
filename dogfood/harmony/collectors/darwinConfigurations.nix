_: {
  config,
  lib,
  ...
}: {
  options.darwinConfigurations = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf raw);
    default = config.synergy.result.systemless.darwinConfigurations or {};
    readOnly = true;
  };

  config = let
    cfg = config.darwinConfigurations;
    export = config.synergy.export.darwinConfigurations or (c: (lib.attrsets.foldAttrs (a: v: a // v) {}) (builtins.attrValues c));
    output = export cfg;
  in {
    synergy.collected.darwinConfigurations.systemless = true;
    flake = lib.mkIf (output != {}) {darwinConfigurations = output;};
  };
}
