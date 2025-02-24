{flake, ...}: {
  pkgs,
  configs ? null,
  log ? true,
}: let
  results = flake.inputs.nixago.lib.${pkgs.system}.makeAll configs;
in
  if !log
  then results // {shellHook = "export NIXAGO_LOG=0\n" + results.shellHook;}
  else results
