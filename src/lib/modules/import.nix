{
  root,
  lib,
  ...
}:
/*
Imports a source file or directory and provides it with the specified arguments.

This function is responsible for loading a source and providing it with a standardized
set of arguments. It handles both single files and recursively loads directories.

Parameters:
  - `unitName`: The name of the unit being loaded
  - `moduleName`: The name of the module being loaded
  - `source`: The source file or directory to import
  - `args`: Arguments to provide to the imported source
  - `squash`: Whether to collapse nested attribute sets into a flat structure (default: false)

The function checks if a module that requires `pkgs` is being loaded in a systemless context,
and throws an error if that's the case, providing clear instructions on how to resolve it.

Returns:
  If `squash` is false, the loaded module(s) as-is.
  If `squash` is true, a flattened attribute set combining all nested attributes.

Errors:
  - If a module requires `pkgs` but is loaded in a systemless context
*/
{
  unitName,
  moduleName,
  source,
  args,
  squash ? false,
}: let
  load = src: let
    imported = builtins.import src;
    systemized = (args.pkgs or null) != null;
    result =
      if lib.trivial.isFunction imported
      then
        lib.trivial.throwIf ((builtins.hasAttr "pkgs" (builtins.functionArgs imported)) && !systemized)
        ''
          Error loading module: ${unitName}.${moduleName} at ${src}
          ------------------------------------------------------------
          This module requires the 'pkgs' attribute, but was loaded in a systemless context.
          The 'pkgs' attribute is only available in systemized results.

          Possible solutions:
          1. Use a systemized result instead
          2. Access pkgs via the 'results' attribute instead
          3. Make the module systemless
        '' (imported (args // {_synergy = {inherit unitName moduleName;};}))
      else imported;
  in
    if squash
    then {
      _synergy = true;
      inherit result;
    }
    else result;

  loaded =
    if builtins.isAttrs source
    then (lib.mapAttrsRecursive (_: load) source)
    else load source;
in
  if squash
  then root.attrsets.recursiveMerge (builtins.map (x: x.result) (lib.attrsets.collect (x: builtins.hasAttr "_synergy" x) loaded))
  else loaded
