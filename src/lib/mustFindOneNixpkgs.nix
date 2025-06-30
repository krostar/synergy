{lib}:
# This function provides intelligent nixpkgs input discovery where configuration
# don't explicitly specify which nixpkgs instance to use. It implements
# a heuristic-based approach to automatically identify the correct nixpkgs
# input from a flake's input set, handling common naming conventions and
# providing clear feedback when disambiguation is needed.
#
# Key Features:
# - automatic nixpkgs input detection using naming conventions
# - support for standard "nixpkgs" and prefixed "nixpkgs-*" naming patterns
# - intelligent disambiguation with helpful warning messages
# - graceful handling of ambiguous or missing nixpkgs inputs
# - integration with Synergy's evaluation pipeline
#
# Example Scenarios:
#   single nixpkgs:
#     inputs = { nixpkgs.url = "..."; }
#     -> Returns: nixpkgs input
#
#   multiple nixpkgs variants:
#     inputs = {
#       nixpkgs-stable.url = "...";
#       nixpkgs-unstable.url = "...";
#     }
#     -> Returns: null (with warning about ambiguity)
#
#   no nixpkgs:
#     inputs = { flake-utils.url = "..."; }
#     -> Returns: null (with warning about missing nixpkgs)
inputs: let
  inputsNixpks = builtins.attrValues (
    lib.attrsets.filterAttrs (
      name: _: name == "nixpkgs" || lib.strings.hasPrefix "nixpkgs-" name
    )
    inputs
  );

  inputsNixpkgsLen = builtins.length inputsNixpks;
in
  if inputsNixpkgsLen == 0
  then
    lib.trivial.warn
    "nixpkgs is not explicitely provided and no inputs were found with names 'nixpkgs' or 'nixpkgs-*'"
    null
  else if (builtins.length inputsNixpks > 1)
  then
    lib.trivial.warn
    "nixpkgs is not explicitely provided and multiple inputs were found with names 'nixpkgs' or 'nixpkgs-*', can't guess which one to use"
    null
  else builtins.head inputsNixpks
