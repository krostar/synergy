{
  data,
  synergy-lib,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.lint-nix = {
      alejandra.exclude = lib.mkOption {type = synergy-lib.modules.types.uniqueListOf lib.types.str;};
      statix.ignore = lib.mkOption {type = synergy-lib.modules.types.uniqueListOf lib.types.str;};
      deadnix.exclude = lib.mkOption {type = synergy-lib.modules.types.uniqueListOf lib.types.str;};
    };
  });
}
