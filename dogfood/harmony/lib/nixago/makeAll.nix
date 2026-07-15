{lib, ...}: {
  pkgs,
  configs ? null,
  log ? true,
}: let
  results = import ./_core/makeAll.nix {inherit pkgs lib;} configs;
in
  if !log
  then results // {shellHook = "export NIXAGO_LOG=0\n" + results.shellHook;}
  else results
