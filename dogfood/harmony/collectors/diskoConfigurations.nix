_: {
  config,
  lib,
  ...
}: {
  options.diskoConfigurations = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf raw);
    default = config.synergy.result.systemless.diskoConfigurations or {};
    readOnly = true;
  };

  config = let
    cfg = config.diskoConfigurations;
    export =
      config.synergy.export.diskoConfigurations
      or (
        c:
          builtins.listToAttrs (
            lib.attrsets.collect (v: builtins.hasAttr "name" v && builtins.hasAttr "value" v) (
              lib.attrsets.mapAttrsRecursiveCond
              (v: builtins.isAttrs v && !lib.attrsets.hasAttrByPath ["disko" "devices"] v)
              (k: v: lib.attrsets.nameValuePair (builtins.concatStringsSep "." k) v)
              c
            )
          )
      );
    output = export cfg;
  in {
    synergy.collected.diskoConfigurations.systemless = true;
    flake = lib.mkIf (output != {}) {diskoConfigurations = output;};
  };
}
