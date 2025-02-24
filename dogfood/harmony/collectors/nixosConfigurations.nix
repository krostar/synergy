_: {
  config,
  lib,
  ...
}: {
  options.nixosConfigurations = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf raw);
    default = config.synergy.result.systemless.nixosConfigurations or {};
    readOnly = true;
  };

  config = let
    cfg = config.nixosConfigurations;
    export =
      config.synergy.export.nixosConfigurations
      or (
        c:
          builtins.listToAttrs (
            lib.attrsets.collect (v: builtins.hasAttr "name" v && builtins.hasAttr "value" v) (
              lib.attrsets.mapAttrsRecursiveCond
              (v: builtins.isAttrs v && !((v._type or "") == "configuration" && (v.class or "") == "nixos"))
              (k: v: lib.attrsets.nameValuePair (builtins.concatStringsSep "." k) v)
              c
            )
          )
      );
    output = export cfg;
  in {
    synergy.collected.nixosConfigurations.systemless = true;
    flake = lib.mkIf (output != {}) {nixosConfigurations = output;};
  };
}
