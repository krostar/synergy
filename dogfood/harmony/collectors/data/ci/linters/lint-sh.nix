{data, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.lint-sh = {
      findFiles = lib.mkOption {type = with lib.types; listOf str;};
      additionalFiles = lib.mkOption {type = with lib.types; listOf str;};
    };
  });
}
