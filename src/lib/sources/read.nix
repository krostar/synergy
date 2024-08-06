{lib}: let
  /*
  Reads the contents of a directory recursively and returns a structured attribute set.

  The returned attribute set follows the directory structure, with keys representing file and directory names.
  The values are either:
    - An attribute set, representing a non-empty subdirectory.
    - A boolean `true`, indicating a regular file ending with ".nix".
  */
  readSource = dir:
    lib.attrsets.filterAttrsRecursive (
      _: value:
        (builtins.isAttrs value && builtins.length (builtins.attrValues value) != 0) || builtins.isBool value
    ) (
      lib.attrsets.mapAttrs (
        file: type:
          if type == "directory"
          then readSource "${dir}/${file}"
          else (type == "regular" && (builtins.stringLength file) > 4 && (lib.strings.hasSuffix ".nix" file))
      ) (builtins.readDir dir)
    );
in
  readSource
