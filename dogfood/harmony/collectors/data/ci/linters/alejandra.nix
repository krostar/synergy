{
  data,
  synergy-lib,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.alejandra = {
      enable = lib.mkEnableOption "alejandra";
      settings.exclude = lib.mkOption {
        type = synergy-lib.modules.types.uniqueListOf lib.types.str;
        default = [];
      };
    };
  });
}
