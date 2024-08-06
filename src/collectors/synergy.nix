{
  config,
  flake,
  lib,
  synergy-lib,
  ...
}: let
  cfg = config.synergy;
in {
  options = {
    data = lib.mkOption {
      type = lib.types.submodule {freeformType = lib.types.anything;};
      description = "data model is extensible through custom collectors ; evaluated configuration is an argument provided to synergy modules";
      default = {};
    };

    flake = lib.mkOption {
      type = lib.types.submodule {freeformType = with lib.types; lazyAttrsOf raw;};
      description = "attributes that should be exposed to flake ; its the equivalent of the 'outputs' attribute in a flake.nix file";
      default = {};
    };

    synergy = {
      load = lib.mkOption {
        type = with lib.types; (functionTo raw);
        description = "function receiving the module's configuration and a Nixpkgs instance which returns the final Synergy configuration ; see mkResult";
        internal = true;
        readOnly = true;
      };

      loaded = lib.mkOption {
        type = with lib.types; (attrsOf raw);
        description = "result of calling the `load` function";
        default = {
          systemless = cfg.load config null;
          systemized = lib.attrsets.genAttrs cfg.systems (system: (cfg.load config (cfg.mkPkgsForSystem system)));
        };
        internal = true;
        readOnly = true;
      };

      result = lib.mkOption {
        type = with lib.types; (attrsOf raw);
        description = "synergy sources evaled config";
        default = {
          systemless = cfg.loaded.systemless.result;
          systemized = builtins.mapAttrs (_: v: v.result) cfg.loaded.systemized;
        };
        internal = true;
        readOnly = true;
      };

      dependencies = lib.mkOption {
        type = with lib.types; (attrsOf raw);
        description = "computed dependencies taken from `input`, keeping only units defined in `restrictDependenciesUnits`";
        default = {
          systemless = cfg.loaded.systemless.dependencies;
          systemized = builtins.mapAttrs (_: v: v.dependencies) cfg.loaded.systemized;
        };
        apply = deps: let
          filter = set:
            builtins.mapAttrs (name: input: builtins.mapAttrs (_: units: builtins.removeAttrs units (lib.lists.subtractLists cfg.restrictDependenciesUnits.${name} (builtins.attrNames units))) input.result)
            (builtins.removeAttrs set (lib.lists.subtractLists (builtins.attrNames cfg.restrictDependenciesUnits) (builtins.attrNames set)));
        in {
          systemless = filter deps.systemless;
          systemized = builtins.mapAttrs (_: filter) deps.systemized;
        };
        internal = true;
        readOnly = true;
      };

      restrictDependenciesUnits = lib.mkOption {
        type = with lib.types; (attrsOf (listOf str));
        description = "mapping of dependency names (as defined in `inputs`) to a list of enabled units from those dependencies; this controls which units from a dependency are exposed within the module's `deps` ar ; this is useful for excluding specific units from a dependency when they are not needed or could cause conflicts (eg: data module in repo unit)";
        default = {};
      };

      collectors = lib.mkOption {
        type = with lib.types // synergy-lib.modules.types; attrsOfAnyDepthOf deferredModule;
        description = "collectors that will be loaded after the initial module evalutation ; this is useful when collectors are defined inside synergy";
        default = {
          result = cfg.result.systemless.collectors or {};
          dependencies = builtins.mapAttrs (_: modules: (modules.collectors or {})) cfg.dependencies.systemless;
        };
        apply = collectors: lib.attrsets.collect lib.trivial.isFunction collectors;
      };

      collected = lib.mkOption {
        type = with lib.types;
          attrsOf (submodule {
            options = {
              systemless = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              systemized = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            };
          });
        description = "attribute sets of collectors to define which results they are collecting";
        default = {};
        internal = true;
      };

      mkPkgsForSystem = lib.mkOption {
        type = with lib.types; nullOr (functionTo pkgs);
        description = "allows the customization of the nixpkgs instance (pkgs argument) provided to systemized results";
        default = let
          nixpkgs = synergy-lib.mustFindOneNixpkgs flake.inputs;
        in
          if nixpkgs != null
          then
            (system: let
              overlays = cfg.synergy.result.systemless.overlays.default or null;
            in
              if overlays != null
              then import nixpkgs {inherit system overlays;}
              else nixpkgs.legacyPackages.${system})
          else null;
      };

      export = lib.mkOption {
        type = with lib.types; attrsOf (functionTo raw);
        description = "specifies how collectors should expose results";
        default = {};
        example = lib.literalExpression ''{export = {lib = v: v.synergy;};}'';
      };

      systems = lib.mkOption {
        type = with lib.types; listOf str;
        description = "systems for which systemized modules will be instanciated";
        default = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      };
    };

    assertions = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            assertion = lib.mkOption {type = bool;};
            message = lib.mkOption {type = str;};
          };
        });
      description = "This option allows modules to express conditions that must hold for the evaluation of the synergy configuration to succeed, along with associated error messages for the user.";
      default = [];
      internal = true;
    };

    warnings = lib.mkOption {
      internal = true;
      default = [];
      type = with lib.types; listOf str;
      example = ["The `foo' service is deprecated and will go away soon!"];
      description = "This option allows modules to show warnings to users during the evaluation of the system configuration.";
      apply = warnings: builtins.map (warning: "synergy: ${warning}") warnings;
    };
  };

  config = {
    data = lib.mkMerge (lib.lists.flatten (
      builtins.attrValues (builtins.mapAttrs (_: units: builtins.attrValues (builtins.mapAttrs (_: modules: builtins.attrValues (modules.data or {})) units)) cfg.dependencies.systemized)
      ++ builtins.attrValues (builtins.mapAttrs (_: modules: builtins.attrValues (modules.data or {})) cfg.result.systemized)
    ));

    flake._synergy = {
      config = builtins.removeAttrs config ["_module" "assertions" "flake" "warnings"];
      inherit (cfg) load;
    };

    synergy.collected = {
      collectors.systemless = true;
      data.systemized = true;
    };

    assertions = lib.lists.flatten (
      lib.attrsets.mapAttrsToList (_: v: v) (
        lib.attrsets.filterAttrs (_: v: !v.assertion) (
          builtins.mapAttrs (name: module: {
            assertion = !module.systemless && !module.systemized || !module.systemless && module.systemized || module.systemless && !module.systemized;
            message = "module ${name} must use either systemized or systemless output but not both";
          })
          cfg.collected
        )
      )
    );

    warnings = let
      notCollected = lib.lists.subtractLists (builtins.attrNames cfg.collected) (builtins.attrNames cfg.result.systemless);
      impacted = lib.lists.flatten (
        (lib.attrsets.mapAttrsToList (k: v: builtins.map (vv: "${vv}.${k}") v))
        (lib.attrsets.filterAttrs (k: _: lib.lists.any (vv: vv == k) notCollected) ( # keep only modules that are not collected
          builtins.mapAttrs (_: v: builtins.attrNames v) cfg.result.systemless # {module = [units...]}
        ))
      );
    in
      lib.lists.optional (builtins.length notCollected > 0) ''

        the following modules were not collected by any collectors:
        ${lib.strings.concatStringsSep "\n" (builtins.sort builtins.lessThan (builtins.map (v: "- ${v}") impacted))}
        consider defining a collector for those modules to enforce their types and test their usage'';
  };
}
