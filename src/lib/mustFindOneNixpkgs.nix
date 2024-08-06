{lib, ...}:
/*
Attempts to find exactly one Nixpkgs input within the given inputs.

It considers inputs named "nixpkgs" or prefixed with "nixpkgs-".
- If no matching inputs are found, a warning is emitted and `null` is returned.
- If multiple matching inputs are found, a warning is emitted and `null` is returned.
- If exactly one matching input is found, it is returned.
*/
inputs: let
  inputsNixpks = lib.lists.remove null (builtins.attrValues (builtins.mapAttrs (name: value:
    if name == "nixpkgs" || lib.strings.hasPrefix "nixpkgs-" name
    then value
    else null)
  inputs));
  inputsNixpkgsLen = builtins.length inputsNixpks;
in
  if inputsNixpkgsLen == 0
  then lib.trivial.warn "nixpkgs is not explicitely provided and no inputs were found with names 'nixpkgs' or 'nixpkgs-*'" null
  else if (builtins.length inputsNixpks > 1)
  then lib.trivial.warn "nixpkgs is not explicitely provided and multiple inputs were found with names 'nixpkgs' or 'nixpkgs-*', can't guess which one to use" null
  else builtins.head inputsNixpks
