{lib, ...}:
# This function converts synergy module results into nix modules that collectors can use.
# It takes a loaded module and make it accessible to the configuration system while preserving proper error reporting.
#
# The name is derived from nixpkgs's lib.modules.importApply, as it mimic some of its behavior and utility:
# - it is used when declaring a module in a file that refers to values from a different scope
# - it sets the required context in case of errors
#
# Parameters:
#   sources: attribute set containing unit sources organized by unit name
#   moduleName: string name of the module type to process (e.g., "packages", "devShells", "data")
#   systemized: boolean indicating whether the module is system-specific or systemless
#   applyResult: function to apply the result to the nix module config
#
# Returns:
#   list of functions collected from matching modules across all units, to use in a 'imports' statement
#
# Example usage:
#   importApply sources "packages" true (result: {config.flake.packages = result;})
#
# The function works by:
# 1. Iterating through sources
# 2. Checking if each source contains the specified moduleName in any units
# 3. For matching modules, creating wrapper functions that:
#    - Set proper module location for error reporting
#    - Extract the appropriate result based on whether its systemized or systemless
#    - Apply the provided transformation function
# 4. Collecting all functions into a flat list so it can be used with 'imports'
sources: moduleName: systemized: applyResult:
lib.attrsets.collect builtins.isFunction (
  builtins.mapAttrs (
    unitName: modulesSources:
    # check if this unit's sources contains the requested module
      if builtins.hasAttr moduleName modulesSources
      then let
        setDefaultModuleLocation = keys: file: {config, ...}: let
          cfg = config.synergy;
        in
          # set a descriptive module location for error messages
          lib.modules.setDefaultModuleLocation
          ''"${moduleName}" from synergy unit "${unitName}" ($src/${builtins.concatStringsSep "/" ([unitName moduleName] ++ keys)}), file "${file}"''
          (
            applyResult (
              let
                setResultValue = result: lib.attrsets.setAttrByPath keys (lib.attrsets.getAttrFromPath keys result);
              in
                if systemized
                then
                  # for systemized modules, generate attributes for each system
                  lib.attrsets.genAttrs cfg.systems (
                    system:
                      setResultValue cfg.loaded.systemized.${system}.result.${moduleName}.${unitName}
                  )
                else
                  # for systemless modules, directly set the result
                  setResultValue cfg.loaded.systemless.result.${moduleName}.${unitName}
            )
          );
      in
        # handle both single files and directory structures
        if builtins.isAttrs modulesSources.${moduleName}
        then
          lib.attrsets.mapAttrsRecursive
          (keys: value: setDefaultModuleLocation keys value)
          modulesSources.${moduleName}
        else setDefaultModuleLocation [] modulesSources.${moduleName}
      else null # unit doesn't contain this module, return null, filtered out
  )
  sources
)
