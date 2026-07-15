{lib, ...}: {
  pkgs,
  data ? null,
  file ? null,
  config ? null,
  update ? cfg: cfg,
  log ? true,
}: let
  nixagoConfig =
    if config == null
    then file data pkgs
    else config;

  result = import ./_core/make.nix {inherit pkgs lib;} (update nixagoConfig);
in
  if !log
  then result // {shellHook = "export NIXAGO_LOG=0\n" + result.shellHook;}
  else result
