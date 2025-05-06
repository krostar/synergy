{
  data,
  synergy-lib,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.statix = {
      enable = lib.mkEnableOption "statix";
      settings.ignore = lib.mkOption {
        type = synergy-lib.modules.types.uniqueListOf lib.types.str;
        default = [];
      };
    };
  });
}
