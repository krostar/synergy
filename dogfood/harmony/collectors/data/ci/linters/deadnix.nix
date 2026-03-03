{
  synergy-lib,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.deadnix = {
      enable = lib.mkEnableOption "deadnix";
      settings.exclude = lib.mkOption {
        type = synergy-lib.modules.types.uniqueListOf lib.types.str;
        default = [];
      };
    };
  });
}
