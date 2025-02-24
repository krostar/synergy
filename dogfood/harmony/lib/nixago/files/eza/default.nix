{unit, ...}: data: pkgs: let
  engines = unit.lib.nixago.engines pkgs;
  output = "eza/theme.yml";
in {
  inherit data output;
  format = "yaml";
  engine = engines.cue {
    files = [./schema.cue];
  };
}
