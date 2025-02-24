_: {
  config,
  lib,
  synergy-lib,
  ...
}: {
  options = {
    nixosModules = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.nixosModules or {};
      readOnly = true;
    };

    nixosProfiles = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.nixosProfiles or {};
      readOnly = true;
    };
  };

  config = let
    export =
      config.synergy.export.nixosModules
      or (m: p:
        synergy-lib.attrsets.liftChildren "-" m
        // (
          let profiles = synergy-lib.attrsets.liftChildren "-" p; in lib.attrsets.optionalAttrs (profiles != {}) {inherit profiles;}
        ));
    output = export config.nixosModules config.nixosProfiles;
  in {
    synergy.collected = {
      nixosModules.systemless = true;
      nixosProfiles.systemless = true;
    };
    flake = lib.mkIf (output != {}) {nixosModules = output;};
  };
}
