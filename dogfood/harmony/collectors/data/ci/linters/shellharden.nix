{
  data,
  synergy-lib,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.shellharden = {
      enable = lib.mkEnableOption "shellharden";
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
