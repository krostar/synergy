{
  lib,
  root,
  super,
}:
# This function provides the core functionality for creating synergy evaluation results.
# It serves as the foundation for the evaluation system, preparing the essential
# components needed for module loading and dependency resolution.
#
# Key Responsibilities:
# - flake context preparation - extract and structure flake information
# - source collection - gather and filter synergy sources from the filesystem
# - load function creation - provide the main loading interface for modules
# - dependency resolution - handle synergy dependencies between flakes
#
# The result structure serves as the bridge between flake inputs and the
# module evaluation system, providing all necessary context for proper
# module instantiation and cross-flake dependency resolution.
{
  src ? null, # optional path to directory containing synergy sources
  inputs, # flake inputs containing 'self' and other flake dependencies
}: let
  # extract and structure essential flake information from inputs
  flake = let
    self' =
      lib.trivial.throwIfNot (builtins.hasAttr "self" inputs)
      "provided inputs does not contains self, please provide all flake's output function arguments"
      inputs.self;
  in {
    # extract core flake metadata for identification and validation
    inherit (self') outPath narHash;

    # separate regular inputs from the special 'self' input
    # This provides clean access to dependency flakes
    inputs = builtins.removeAttrs inputs ["self"];

    # preserve the complete flake outputs for full access
    outputs = self';

    # identify synergy-capable dependencies
    synergies =
      lib.attrsets.filterAttrs
      (_: input: lib.attrsets.hasAttrByPath ["_synergy" "load"] input)
      (builtins.removeAttrs inputs ["self"]);
  };

  # gather synergy sources from the filesystem if a source path is provided
  sources =
    if src != null
    then root.sources.filters.dropNonDirectoryRoots (super.collect src)
    else {}; # no source path provided - return empty source set, this enables purely dependency-based evaluations
in {
  inherit flake sources;

  # this function performs the actual module loading and dependency resolution
  load = config: pkgs: let
    # load all synergy dependencies by calling their load functions
    dependencies =
      builtins.mapAttrs
      (_: input: input._synergy.load config pkgs)
      flake.synergies;

    # retrieve final synergy evaluation from flake output to provide it as a parameter of the synergy module
    results = let
      find = set:
        if flake.narHash == set.flake.narHash
        then set.result
        else lib.lists.findFirst builtins.isAttrs null (lib.lists.flatten (builtins.map find (builtins.attrValues set.dependencies)));
    in {
      systemless = find config.synergy.loaded.systemless;
      systemized = builtins.mapAttrs (_: find) config.synergy.loaded.systemized;
    };

    # load synergy sources
    result = root.attrsets.swapLevels (
      super.load {
        inherit sources;
        args = {
          inherit flake lib results;
          inherit (config) data;
          deps = dependencies;
        };
      }
      pkgs
    );
  in {
    inherit flake sources dependencies result results;
  };
}
