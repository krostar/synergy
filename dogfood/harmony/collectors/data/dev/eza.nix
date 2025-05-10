{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.eza = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
    };
  });
}
