{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    dev.intellij-idea.file-watchers = {
      enable = lib.mkEnableOption "intellij-idea file-watchers";
      tasks = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        default = [];
      };
    };
  });
}
