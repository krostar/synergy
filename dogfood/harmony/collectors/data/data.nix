{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci = lib.mkOption {type = lib.types.submodule {};};
    dev = lib.mkOption {type = lib.types.submodule {};};
  });
}
