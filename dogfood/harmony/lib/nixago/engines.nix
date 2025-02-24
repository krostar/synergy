{flake, ...}: pkgs: flake.inputs.nixago.engines.${pkgs.system}
