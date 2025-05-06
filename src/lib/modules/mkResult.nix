{
  lib,
  root,
  super,
}: {
  src, # path to the directory containing sources
  inputs, # flake inputs, containing self
}: let
  flake = let
    self' = lib.trivial.throwIfNot (builtins.hasAttr "self" inputs) "provided inputs does not contains self, please provide all flake's output function arguments" inputs.self;
  in {
    inherit (self') outPath narHash;
    inputs = builtins.removeAttrs inputs ["self"];
    outputs = self';
  };
in {
  inherit flake;
  load = config: pkgs: let
    dependencies = builtins.mapAttrs (_: input: input._synergy.load config pkgs) (
      lib.attrsets.filterAttrs (_: input: lib.attrsets.hasAttrByPath ["_synergy" "load"] input) (builtins.removeAttrs inputs ["self"])
    );
    results = let
      find = set:
        if flake.narHash == set.flake.narHash
        then set.result
        else lib.lists.findFirst builtins.isAttrs null (lib.lists.flatten (builtins.map find (builtins.attrValues set.dependencies)));
    in {
      systemless = find config.synergy.loaded.systemless;
      systemized = builtins.mapAttrs (_: find) config.synergy.loaded.systemized;
    };
    result = root.attrsets.swapLevels (
      super.load {
        args = {
          inherit flake lib results;
          inherit (config) data;
          deps = dependencies;
        };
        sources =
          if src != null
          then root.sources.filters.dropNonDirectoryRoots (super.collect src)
          else {};
      }
      pkgs
    );
  in {inherit dependencies flake result results;};
}
