{
  root,
  lib,
}:
# This function provides the core functionality for importing individual modules from sources.
#
# Key Features:
# - supports both function-based and direct value modules
# - handles systemized vs systemless contexts with proper error reporting
# - recursive loading of nested module structures
# - optional squashing (flattening) of hierarchical results
# - comprehensive error context for debugging
{
  source, # path to module source file, or nested attrset of sources for recursive loading
  args, # arguments to pass to the module during instantiation
  squash ? false, # whether to flatten/merge nested module results into a single attrset
}: let
  load = src: let
    # provide enhanced error context for debugging failed module loads
    addErrorContext = builtins.addErrorContext "error loading synergy module at ${src}";

    # import the module source file - this could be a function or direct value
    imported = builtins.import src;

    # determine if we're in a systemized context (nixpkgs available)
    # this is used to validate module requirements vs available context
    systemized = (args.pkgs or null) != null;

    # process the imported module based on its type and requirements
    result =
      # check if the imported module is a function (most common case)
      if lib.trivial.isFunction imported
      then
        # if module requires 'pkgs' but we're in systemless context, throw helpful error
        lib.trivial.throwIf ((builtins.hasAttr "pkgs" (builtins.functionArgs imported)) && !systemized)
        ''
          In file ${src}:
          ------------------------------------------------------------
          This module requires the 'pkgs' attribute, but was loaded in a systemless context.
          The 'pkgs' attribute is only available in systemized results.

          Possible solutions:
          1. Use a systemized result instead
          2. Access the 'results' attribute instead
          3. Make the module systemless
          ------------------------------------------------------------
        '' (addErrorContext (imported args))
      # handle direct value modules (less common, but supported)
      else addErrorContext imported;
  in
    if squash
    then {
      # mark this for collection during squash phase
      _synergy = true;
      inherit result;
    }
    else result;

  # call load for each sources
  loaded =
    if builtins.isAttrs source
    then lib.mapAttrsRecursive (_: load) source
    else load source;
in
  if squash
  then
    # squashing mode: flatten all nested results into a single attribute set
    root.attrsets.recursiveMerge (
      builtins.map (x: x.result) (
        lib.attrsets.collect (x:
          builtins.hasAttr "_synergy" x)
        loaded
      )
    )
  else
    # normal mode: return the loaded structure as-is, preserving hierarchy
    loaded
