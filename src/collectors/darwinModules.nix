{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options = {
    darwinModules = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.darwinModules or {};
      readOnly = true;
    };

    darwinProfiles = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf raw);
      default = config.synergy.result.systemless.darwinProfiles or {};
      readOnly = true;
    };
  };

  config = let
    export =
      config.synergy.export.darwinModules
      or (m: p: synergy-lib.attrsets.liftChildren "-" m // {profiles = synergy-lib.attrsets.liftChildren "-" p;});
    output = export config.darwinModules config.darwinProfiles;
  in {
    synergy.collected = {
      darwinModules.systemless = true;
      darwinProfiles.systemless = true;
    };
    flake = lib.mkIf (output != {}) {darwinModules = output;};
  };
}
