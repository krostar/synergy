{unit, ...}: data: pkgs: let
  engines = unit.lib.nixago.engines pkgs;
  output = ".ecrc";
in {
  inherit data output;
  format = "json";
  engine = engines.cue {
    files = [./schema.cue];
  };
}
