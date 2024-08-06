{
  lib,
  root,
  super,
  synergy-collectors,
}: let
  inherit (root) sources attrsets;
in
  /*
  Load sources and evaluate module.

  about sources:
    - only regular files ending with `.nix` are loaded
    - if a file and a directory share the same name (except the file extension), the nix file takes precedence and the directory is not loaded
    - if a `default.nix` file is present at any depth, only that file is loaded, other files at that depth and descendants from that point onward won't be loaded
  */
  {
    src, # path to the directory containing sources
    inputs, # flake inputs, containing self
    eval ? {}, # inline module configuration
    collectors ? (builtins.attrValues synergy-collectors), # list of collectors
  }: let
    collectedSources = let
      removeDotNixFromKeys = attrsets.renameKeys (v: lib.strings.removeSuffix ".nix" v);
    in
      attrsets.liftKey "default" (
        removeDotNixFromKeys (sources.collect src (
          lib.lists.foldr (a: a) (sources.read src) (with sources.filters; [
            regularNixFilesOnly
            (preferFilesOverDirectories "nix")
            stopAtDefaultNixFile
            dropPrefixedWithUnderscore
            dropNonDirectoryRoots
          ])
        ))
      );

    flakeInputs = builtins.removeAttrs inputs ["self"];

    flake = {
      directory = inputs.self.outPath;
      inputs = flakeInputs;
      outputs = lib.trivial.throwIfNot (builtins.hasAttr "self" inputs) "provided inputs does not contains self, please provide all flake's output function arguments" inputs.self;
    };

    mkResultWithArgs = args: pkgs:
      attrsets.swapLevels (super.load {
          inherit args;
          sources = collectedSources;
        }
        pkgs);

    initial = lib.evalModules {
      specialArgs = {
        inherit flake;
        synergy-lib = root;
        deps = lib.attrsets.filterAttrs (k: v: v != {}) (builtins.mapAttrs (_: input: lib.attrsets.attrByPath ["synergy" "synergy" "result"] {} input) flakeInputs);
      };
      modules =
        collectors
        ++ [
          ({
            flake,
            config,
            ...
          }: let
            mkResult = mkResultWithArgs {
              inherit lib flake config;
              inherit (config) data;
            };
          in {
            _file = ./eval.nix;
            synergy = {
              result = {
                systemless = mkResult null;
                systemized = mkResult;
              };
            };
          })
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
