_: {
  config,
  lib,
  synergy-lib,
  ...
}: {
  options = {
    homeModules = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.homeModules or {};
      readOnly = true;
    };

    homeProfiles = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.homeProfiles or {};
      readOnly = true;
    };
  };

  config = let
    export =
      config.synergy.export.homeModules
      or (m: p:
        synergy-lib.attrsets.liftChildren "-" m
        // (
          let profiles = synergy-lib.attrsets.liftChildren "-" p; in lib.attrsets.optionalAttrs (profiles != {}) {inherit profiles;}
        ));
    output = export config.homeModules config.homeProfiles;
  in {
    synergy.collected = {
      homeModules.systemless = true;
      homeProfiles.systemless = true;
    };
    flake = lib.mkIf (output != {}) {homeModules = output;};
  };
}
