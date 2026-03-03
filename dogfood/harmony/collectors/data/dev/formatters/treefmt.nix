{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    dev.formatters.treefmt = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
    };
  });
}
