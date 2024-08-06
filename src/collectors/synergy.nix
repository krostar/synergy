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
      result = lib.mkOption {
        type = lib.types.submodule {
          options = {
            systemless = lib.mkOption {
              type = with lib.types; attrsOf raw;
              description = "result per systems";
            };
            systemized = lib.mkOption {
              type = with lib.types; functionTo (attrsOf raw);
              description = "systemless result";
              apply = v: lib.attrsets.genAttrs cfg.systems (system: v (cfg.mkPkgsForSystem system));
            };
          };
        };
        description = "result of evaluating synergy sources ; aka synergy module evaled config";
        internal = true;
        readOnly = true;
      };

      collectors = lib.mkOption {
        type = with lib.types; listOf deferredModule;
        description = "collectors that will be loaded after the initial module evalutation ; this is useful when collectors are defined inside synergy";
        default = lib.attrsets.collect lib.trivial.isFunction (cfg.result.systemless.collectors or {});
        internal = true;
        readOnly = true;
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
          then (system: nixpkgs.legacyPackages.${system})
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
    data = lib.mkMerge (lib.lists.flatten (builtins.attrValues (builtins.mapAttrs (_: modules: builtins.attrValues (modules.data or {})) cfg.result.systemized)));

    flake.synergy = builtins.removeAttrs config ["_module"];

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
        (lib.attrsets.mapAttrsToList (k: v: builtins.map (vv: "${vv}.${k}") v)) # join units.module
        
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
