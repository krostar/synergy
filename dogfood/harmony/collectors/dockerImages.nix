_: {
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.dockerImages = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (attrsOf package));
    default = lib.attrsets.filterAttrs (_: v: v != {}) (builtins.mapAttrs (_: m: m.dockerImages or {}) config.synergy.result.systemized);
    readOnly = true;
  };

  config = let
    cfg = config.dockerImages;
    export =
      config.synergy.export.dockerImages
      or (
        builtins.mapAttrs (_: m: (synergy-lib.attrsets.liftChildren "-" m))
      );
    output = export cfg;
  in {
    synergy.collected.dockerImages.systemized = true;
    flake = lib.mkIf (output != {}) {dockerImages = output;};
  };
}
