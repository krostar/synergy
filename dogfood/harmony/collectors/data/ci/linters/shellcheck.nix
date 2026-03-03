{
  synergy-lib,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.shellcheck = {
      enable = lib.mkEnableOption "shellcheck";
      settings.include = {
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
  });
}
