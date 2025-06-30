{
  lib,
  root,
}:
# This function provides the core functionality for loading and instantiating
# synergy modules across different units. It creates a hierarchical structure
# where units contain modules, and each module is properly instantiated with
# the necessary context and dependencies.
{
  sources, # result of calling sources.collect - nested attrset of unit -> module -> source
  args, # base arguments to provide to all loaded modules
}:
# nixpkgs instance for systemized loading, or null for systemless instance
pkgs: let
  systemized = pkgs != null;

  units = builtins.mapAttrs (_: modules: (let
    unit =
      builtins.mapAttrs (
        _: source: (
          root.modules.import {
            inherit source;

            args =
              args
              // {
                # provide access to itself (unit)
                # and other units for cross-units dependencies (units)
                inherit units unit;
                # provide access to synergy library functions
                synergy-lib = root;
              }
              # conditionally add nixpkgs in systemized mode
              // (lib.attrsets.optionalAttrs systemized {inherit pkgs;});
          }
        )
      )
      modules;
  in
    unit))
  sources;
in
  # return the complete hierarchy of instantiated modules
  # final structure: { <unitName> = { <moduleName> = <module>; }; }
  units
