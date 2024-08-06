{
  config,
  lib,
  ...
}: {
  options.formatter = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf package);
    default = lib.attrsets.filterAttrs (_: v: v != {}) (builtins.mapAttrs (_: m: m.formatter or {}) config.synergy.result.systemized);
    readOnly = true;
  };

  config = let
    cfg = config.formatter;
    export =
      config.synergy.export.formatter
      or (builtins.mapAttrs (
        _: m: let
          formatter = builtins.attrValues m;
          len = builtins.length formatter;
        in
          if (len > 1)
          then builtins.throw "multiple formatter configured: don't know how to choose"
          else if (len == 1)
          then (builtins.head formatter)
          else {}
      ));
    output = export cfg;
  in {
    synergy.collected.formatter.systemized = true;
    flake = lib.mkIf (output != {}) {formatter = output;};
  };
}
