{
  root,
  lib,
}:
# This function provides the core functionality for collecting and filtering
# sources from the filesystem. It implements a filtering pipeline that transforms
# raw directory structures into a clean, normalized representation suitable for module loading.
#
# The collection process transforms filesystem structures like:
#   src/
#     unit1/
#       module1.nix
#       module2/
#         default.nix
#     unit2/
#       _private.nix (excluded)
#       public.nix
#
# Into normalized attribute sets like:
#   {
#     unit1 = {
#       module1 = <source>;
#       module2 = <source>;
#     };
#     unit2 = {
#       public = <source>;
#     };
#   }
let
  # removes the ".nix" suffix from all keys in an attribute set
  # example: { "module.nix" = source; } -> { "module" = source; }
  removeDotNixFromKeys = root.attrsets.renameAttrKeys (v: lib.strings.removeSuffix ".nix" v);
in
  src:
  # move "default" attribute value up one level in the hierarchy
  # example: { dir = { default = source; }; } -> { dir = source; }
    root.attrsets.liftKey "default" (
      removeDotNixFromKeys (
        root.sources.collect src (
          # each filter transforms the source tree, building up the final structure
          # the order matters - later filters operate on the results of earlier ones
          lib.lists.foldr (a: a) (root.sources.read src) (
            with root.sources.filters; [
              # dropNonDirectoryRoots is not added here as this function is also used in autoimport
              keepRegularFilesOnly
              (preferFilesOverDirectories "nix")
              stopAtDefaultNixFile
              dropPrefixedWithUnderscore
            ]
          )
        )
      )
    )
