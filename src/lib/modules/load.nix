{
  lib,
  root,
}:
/*
Loads all sources and provides them with a set of arguments.

The following arguments are provided to loaded sources if they are functions:
  - `args`: Provided `args` attributes.
  - `pkgs`: Provided only if the `pkgs` argument is not `null`.
  - `synergy-lib`: Synergy library.
  - `unit`: Current unit modules.
  - `units`: All units modules.

If a loaded source is not a function, it is loaded without any arguments.
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
                while trying to load ${unitName}.${module} at ${toLoad}:
                the pkgs attribute is only available in systemized result
                trying to access pkgs via a systemless result is possible through `results`
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
