{
  flake,
  lib,
  synergy-lib,
  synergy-sources,
  ...
}: {
  options = {
    data = lib.mkOption {
      type = lib.types.submodule {freeformType = with lib.types; lazyAttrsOf anything;};
      description = "data model is extensible through custom collectors ; evaluated configuration is an argument provided to synergy modules";
      default = {};
    };
  };

  imports =
    lib.lists.flatten (builtins.attrValues (
      builtins.mapAttrs (input: dep:
        builtins.map (unit: (
          lib.modules.setDefaultModuleLocation ''"data" from synergy dependency (flake input) "${input}" unit "${unit}"'' (
            {config, ...}: {
              config.data = let
                value = lib.attrsets.filterAttrs (_: v: v != null) (
                  builtins.mapAttrs (
                    _: inputs:
                      inputs.${input}.data.${unit} or null
                  )
                  config.synergy.dependencies.systemized
                );
              in
                lib.mkIf (value != {}) value;
            }
          )
        ))
        dep._synergy.units)
      flake.synergies
    ))
    ++ synergy-lib.modules.importApply synergy-sources "data" true (result: {
      config.data = result;
    });

  config.synergy.collected.data.systemized = true;
}
