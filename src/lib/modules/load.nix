{
  lib,
  root,
}:
/*
Loads all sources and provides them with a set of arguments.

This function is responsible for importing all the source files collected by the
sources.collect function and providing them with a standardized set of arguments.
It distinguishes between systemized (with pkgs) and systemless loading contexts.

Parameters:
  - `sources`: The result of calling sources.collect function, containing unit modules to load
  - `args`: Custom arguments to provide to loaded sources
  - `pkgs`: Nixpkgs instance for systemized loading, or null for systemless operation

The following arguments are provided to loaded sources if they are functions:
  - `_synergy`: Attribute used internally by synergy, it is not advised to use it
  - `args`: All provided `args` attributes are passed through
  - `pkgs`: Provided only if the `pkgs` argument is not `null` (systemized context)
  - `synergy-lib`: The complete Synergy library for access to all its functions
  - `unit`: The current unit's modules
  - `units`: All units' modules, allowing cross-unit references

If a loaded source is not a function, it is loaded without any arguments.

This function uses circular references to allow modules to reference other modules
in the same unit and across units. A unit can access its own modules via `unit` and
all units via `units`.

Returns:
  An attribute set with the structure: { $unitName = { $moduleName = loadedModule; }; }
  where each loadedModule is the result of importing the source with appropriate arguments.

Errors:
  - If a source requires pkgs but is loaded in a systemless context, the error will be
    raised by the modules.import function with detailed troubleshooting information.
```
*/
{
  sources, # result of calling sources.collect
  args, # arguments to provide to loaded sources
}:
# instanciated nixpkgs, or null for systemless instance
pkgs: let
  systemized = pkgs != null;

  # units contains modules for all units
  units = builtins.mapAttrs (unitName: modules: (let
    # unit contains all modules for current unit
    unit =
      builtins.mapAttrs (
        moduleName: source:
          root.modules.import {
            inherit unitName moduleName source;
            args =
              args
              // {
                inherit units unit;
                synergy-lib = root;
              }
              // (lib.attrsets.optionalAttrs systemized {inherit pkgs;});
          }
      )
      modules;
  in
    unit))
  sources;
in
  units
