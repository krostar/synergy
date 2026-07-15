# Vendored and adapted from nixago (https://github.com/nix-community/nixago).
# MIT License; Copyright (c) 2022 Joshua Gilman. See ../LICENSE.
{
  pkgs,
  lib,
}: {
  name,
  configFile,
  hookConfig,
}: let
  # common contains shared code across hooks
  common = import ./common.nix;

  # load hook file based on mode passed
  hookFile = ./. + "/${hookConfig.mode}.nix";
  hook = import hookFile {inherit configFile hookConfig;};

  # use writeShellScript for integrated error checking
  shellScript = pkgs.writeShellScript "nixago_${name}_hook" hook;

  prefixStringLines = prefix: str:
    lib.strings.concatMapStringsSep "\n" (line: prefix + line) (lib.strings.splitString "\n" str);
  indent = prefixStringLines "  ";
in {
  inherit shellScript;
  shellHook = ''
    nixago() (
    ${indent common}

      cd "''${PRJ_ROOT:-.}"
      run_if_trace set -x
      source ${shellScript}
      run_if_trace set +x
    )
    nixago
    unset -f nixago
  '';
}
