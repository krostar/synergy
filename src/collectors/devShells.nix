{
  config,
  lib,
  synergy-lib,
  ...
}: {
  options.devShells = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf (attrsOf package));
    default = builtins.mapAttrs (_: m:
      lib.attrsets.mapAttrs (_: v:
        if lib.attrsets.isDerivation v
        then {default = v;}
        else v) (m.devShells or {}))
    config.synergy.result.systemized;
    readOnly = true;
  };

  config = let
    cfg = config.devShells;
    export =
      config.synergy.export.devShells
      or (builtins.mapAttrs (
        _: v: let
          shells = synergy-lib.attrsets.liftChildren "-" v;
          shellValues = builtins.attrValues shells;
        in
          if builtins.length shellValues == 1
          then {default = builtins.head shellValues;}
          else shells
      ));
    output = export cfg;
  in {
    synergy.collected.devShells.systemized = true;
    flake = lib.mkIf (output != {}) {devShells = output;};
  };
}
