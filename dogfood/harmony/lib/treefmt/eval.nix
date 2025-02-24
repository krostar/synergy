{
  flake,
  unit,
  ...
}: {
  config,
  pkgs,
}:
flake.inputs.treefmt.lib.evalModule pkgs {
  imports = [
    unit.lib.treefmt.options.gci
    config
  ];
}
