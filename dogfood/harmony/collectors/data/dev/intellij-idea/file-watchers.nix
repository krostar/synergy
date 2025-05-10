{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    dev.intellij-idea.file-watchers = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = {};
    };
  });
}
