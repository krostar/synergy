{flake, ...}: pkgs: flake.inputs.nixago.engines.${pkgs.stdenv.hostPlatform.system}
