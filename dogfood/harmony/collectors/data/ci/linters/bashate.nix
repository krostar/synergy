{
  synergy-lib,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.bashate = {
      enable = lib.mkEnableOption "bashate";
      settings = {
        ignore = lib.mkOption {
          type = synergy-lib.modules.types.uniqueListOf lib.types.str;
          default = [];
        };
        include = {
          find = lib.mkOption {
            type = synergy-lib.modules.types.uniqueListOf lib.types.str;
            default = [];
          };
          files = lib.mkOption {
            type = synergy-lib.modules.types.uniqueListOf lib.types.str;
            default = [];
          };
        };
      };
    };
  });
}
