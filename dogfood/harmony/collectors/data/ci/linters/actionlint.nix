{
  data,
  synergy-lib,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.actionlint = {
      enable = lib.mkEnableOption "actionlint";
      settings.ignore = lib.mkOption {
        type = synergy-lib.modules.types.uniqueListOf lib.types.str;
        default = [];
      };
    };
  });
}
