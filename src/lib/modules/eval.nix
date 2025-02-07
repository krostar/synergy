{
  lib,
  root,
  super,
  synergy-collectors,
}:
/*
Load sources and evaluate module.
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

    Failed assertions:
    ${lib.strings.concatStringsSep "\n" (builtins.map (x: "- ${x}") failedAssertions)}
  '';
  showWarnings = lib.trivial.showWarnings final.config.warnings;
in
  showWarnings (throwAsserts final)
