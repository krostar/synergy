{
  root,
  lib,
  ...
}: let
  ## remove the ".nix" suffix from all keys in an attribute set.
  removeDotNixFromKeys = root.attrsets.renameKeys (v: lib.strings.removeSuffix ".nix" v);
in
  /*
  Recursively collect Nix source files from a directory and return them as an attribute set.

  The function reads the contents of the directory specified by `src` and applies a series of filters to select the relevant files.
  - only regular files ending with `.nix` are loaded
  - if a file and a directory share the same name (except the file extension), the nix file takes precedence and the directory is not loaded
  - if a `default.nix` file is present at any depth, only that file is loaded, other files at that depth and descendants from that point onward won't be loaded
  */
  src:
    root.attrsets.liftKey "default" (
      removeDotNixFromKeys (root.sources.collect src (
        lib.lists.foldr (a: a) (root.sources.read src) (with root.sources.filters; [
          regularNixFilesOnly
          (preferFilesOverDirectories "nix")
          stopAtDefaultNixFile
          dropPrefixedWithUnderscore
          dropNonDirectoryRoots
        ])
      ))
    )
