{
  haumea,
  lib,
}: let
  synergy-collectors = haumea.lib.load {
    src = ./collectors;
    loader = haumea.lib.loaders.path;
  };

  synergy-lib = haumea.lib.load {
    src = ./lib;
    inputs = {inherit lib synergy-collectors;};
  };
in {
  lib = synergy-lib;
  collectors = synergy-collectors;
}
