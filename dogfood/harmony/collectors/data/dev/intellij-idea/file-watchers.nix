{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    dev.intellij-idea.file-watchers = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = {};
    };
  });
}
