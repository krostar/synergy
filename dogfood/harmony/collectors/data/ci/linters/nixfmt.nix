{
  synergy-lib,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.nixfmt = {
      enable = lib.mkEnableOption "nixfmt";
      settings.include = lib.mkOption {
        type = synergy-lib.modules.types.uniqueListOf lib.types.str;
        default = [];
      };
    };
  });
}
