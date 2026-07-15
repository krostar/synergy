# Vendored and adapted from nixago (https://github.com/nix-community/nixago).
# MIT License; Copyright (c) 2022 Joshua Gilman. See ../LICENSE.
/*
The nix engine uses pkgs.formats for generating output data.

The engine takes a single parameter (`opts`) which is subsequently passed to
the specified generator when instantiating it. See the pkgs.formats entries
for which options are available for each generator type.

The `format` field of the request determines which generator is invoked. The
format must be a name in the set produced by `pkgs.formats`.
*/
{
  pkgs,
  lib,
}: opts: request: let
  inherit (request) data format output;

  # Default the derivation name to the basename of the output file.
  name = builtins.baseNameOf output;
in
  # Validate that the format specified is supported by pkgs.formats
  assert lib.asserts.assertMsg (pkgs.formats ? "${format}") "Invalid type specified: ${format}";
    (pkgs.formats.${format} opts).generate name data
