{
  lib,
  root,
  super,
  synergy-collectors,
}:
/*
Load sources and evaluate modules with assertions and warnings.

This function is the core evaluation mechanism of Synergy. It loads sources,
instantiates modules with collectors, and handles validation through assertions and warnings.

Parameters:
  - `inputs`: Flake inputs, including self reference
  - `eval`: Optional inline module configuration
  - `collectors`: List of collectors to use (defaults to all available collectors)
  - `src`: Path to the directory containing sources (can be null for no sources)

The evaluation occurs in two phases:
1. Initial evaluation with collectors, src loading, and eval module
2. Extended evaluation if initial config contains additional collectors

Returns:
  The evaluated module result with processed assertions and warnings

Errors:
  - Throws an error if any assertions fail, with a list of all failed assertions

See collect.nix for more details about how sources are loaded.
*/
{
  inputs, # flake inputs, containing self
  eval ? {}, # inline module configuration
  collectors ? (builtins.attrValues synergy-collectors), # list of collectors
  src ? null, # path to the directory containing sources
}: let
  mkResult = super.mkResult {inherit src inputs;};

  initial = lib.evalModules {
    specialArgs = {
      synergy-lib = root;
      inherit (mkResult) flake;
    };
    modules =
      collectors
      ++ [
        {
          _file = ./eval.nix;
          synergy = {inherit (mkResult) load;};
        }
        eval
      ];
  };

  final =
    if builtins.length initial.config.synergy.collectors > 0
    then initial.extendModules {modules = initial.config.synergy.collectors;}
    else initial;

  failedAssertions = builtins.map (x: x.message) (builtins.filter (x: !x.assertion) final.config.assertions);
  throwAsserts = lib.trivial.throwIf (failedAssertions != []) ''
    ╭────────────────────────────────────────────────╮
    │                EVALUATION ERROR                │
    ╰────────────────────────────────────────────────╯

    The following assertions failed during Synergy module evaluation:
    ${lib.strings.concatStringsSep "\n" (builtins.map (x: "  ✗ ${x}") failedAssertions)}

    Check your configuration and ensure all requirements are met.
  '';
  showWarnings = lib.trivial.showWarnings final.config.warnings;
in
  showWarnings (throwAsserts final)
