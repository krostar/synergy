{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.yamllint = {
      enable = lib.mkEnableOption "yamllint";
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
      };
    };
  });
}
