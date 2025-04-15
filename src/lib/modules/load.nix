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
  - `args`: Provided `args` attributes
  - `pkgs`: Provided only if the `pkgs` argument is not `null`
  - `synergy-lib`: Synergy library
  - `unit`: Current unit modules
  - `units`: All units modules

If a loaded source is not a function, it is loaded without any arguments.

Returns:
  An attribute set with the structure: { unitName = { moduleName = loadedModule; }; }

Errors:
  - If a source requires pkgs but is loaded in a systemless context
*/
{
  sources, # result of calling sources.collect
  args, # arguments to provide to loaded sources
}:
# instanciated nixpkgs, or null for systemless instance
pkgs: let
  systemized = pkgs != null;

  # units contains modules for all units
  units = builtins.mapAttrs (module: modules: (let
    # unit contains all modules for current unit
    unit =
      builtins.mapAttrs (
        unitName: source: let
          loadArgs =
            args
            // (lib.attrsets.optionalAttrs systemized {inherit pkgs;})
            // {
              inherit units unit;
              synergy-lib = root;
            };

          load = toLoad: let
            loaded = builtins.import toLoad;
          in
            if lib.trivial.isFunction loaded
            then
              lib.trivial.throwIf ((builtins.hasAttr "pkgs" (builtins.functionArgs loaded)) && !systemized)
              ''
                Error loading module: ${unitName}.${module} at ${toLoad}
                ------------------------------------------------------------
                This module requires the 'pkgs' attribute, but was loaded in a systemless context.
                The 'pkgs' attribute is only available in systemized results.

                Possible solutions:
                1. Use a systemized result instead
                2. Access pkgs via the 'results' attribute instead
                3. Make the module systemless
              '' (loaded loadArgs)
            else loaded;
        in
          if builtins.isAttrs source
          then (lib.mapAttrsRecursive (_: load) source)
          else load source
      )
      modules;
  in
    unit))
  sources;
in
  units
