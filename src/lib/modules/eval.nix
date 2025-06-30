{
  lib,
  root,
  super,
  synergy-collectors,
}:
# This function provides the core evaluation engine for synergy configurations.
# It orchestrates the complete evaluation process from source collection through
# module instantiation to final configuration validation.
#
# The evaluation process follows these phases:
# 1. result preparation - create base result with sources and loading capabilities
# 2. initial evaluation - evaluate core modules with collectors and inline config
# 3. extended evaluation - process any additional collectors discovered during initial eval
# 4. validation - check assertions and display eventual warnings
# 5. final result - return nix module
{
  inputs, # flake inputs containing 'self' and other flake dependencies
  eval ? {}, # inline module configuration to merge with collected modules
  collectors ? (builtins.attrValues synergy-collectors), # list of collector modules to use for gathering sources
  src ? null, # path to directory containing synergy sources (nothing loaded if null)
}: let
  # create the base result containing sources, loading functions, and flake context
  mkResult = super.mkResult {inherit src inputs;};

  # evaluate the core module system with collectors and any inline configuration
  # this creates the base configuration that may specify additional collectors
  initial = lib.evalModules {
    specialArgs = {
      inherit (mkResult) flake;
      synergy-lib = root;
      synergy-sources = mkResult.sources;
    };

    modules =
      collectors
      ++ [
        (
          lib.modules.setDefaultModuleLocation "synergy evaluation" {
            synergy = {inherit (mkResult) load;};
          }
        )
        eval
      ];
  };

  # if the initial evaluation discovered additional collectors, extend the module system to include them
  final =
    if builtins.length initial.config.synergy.collectors > 0
    then initial.extendModules {modules = initial.config.synergy.collectors;}
    else initial;

  # finally, show warning and assertions
  throwAsserts = let
    failedAssertions = builtins.map (x: x.message) (builtins.filter (x: !x.assertion) final.config.assertions);
  in
    lib.trivial.throwIf (failedAssertions != []) ''
      ╭────────────────────────────────────────────────╮
      │                                EVALUATION ERROR                                │
      ╰────────────────────────────────────────────────╯

      The following assertions failed during Synergy module evaluation:
      ${lib.strings.concatStringsSep "\n" (builtins.map (x: "  ✗ ${x}") failedAssertions)}

      Check your configuration and ensure all requirements are met.
    '';

  showWarnings = lib.trivial.showWarnings final.config.warnings;
in
  showWarnings (throwAsserts final)
