{unit, ...}: data: pkgs: let
  engines = unit.lib.nixago.engines pkgs;
  output = "cliff.toml";
in {
  inherit data output;
  engine = engines.cue {
    files = [./schema.cue];
  };
}
