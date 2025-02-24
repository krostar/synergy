{unit, ...}: data: pkgs: let
  engines = unit.lib.nixago.engines pkgs;
  output = "golangci-lint.yaml";
in {
  inherit data output;
  engine = engines.cue {
    files = [./schema.cue];
  };
}
