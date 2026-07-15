# Vendored and adapted from nixago (https://github.com/nix-community/nixago).
# MIT License; Copyright (c) 2022 Joshua Gilman. See ./LICENSE.
/*
Concatenates a list of configurations together.
*/
{
  pkgs,
  lib,
}: all: let
  outputs = builtins.map (request: request.output or null) all;
  duplicatedOutputs =
    builtins.filter
    (output: output != null && 1 < builtins.length (builtins.filter (other: other == output) outputs))
    (lib.lists.unique outputs);

  result = assert lib.asserts.assertMsg (duplicatedOutputs == []) "nixago makeAll: multiple configurations target the same output path(s): ${builtins.concatStringsSep ", " duplicatedOutputs}";
    builtins.map (import ./make.nix {inherit pkgs lib;}) all;

  prefixStringLines = prefix: str:
    lib.strings.concatMapStringsSep "\n" (line: prefix + line) (lib.strings.splitString "\n" str);
  indent = prefixStringLines "  ";

  shellHook = ''
    nixago() (
      # Common shell code
    ${indent (import ./hooks/common.nix)}

      cd "''${PRJ_ROOT:-.}"
      run_if_trace set -x
      source ${builtins.concatStringsSep "\n  source " (lib.attrsets.catAttrs "shellScript" result)}
      run_if_trace set +x
    )
    nixago
    unset -f nixago
  '';
in {
  inherit shellHook;
  scripts = lib.attrsets.catAttrs "shellScript" result;
  configs = lib.attrsets.catAttrs "configFile" result;
}
