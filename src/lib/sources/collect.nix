{lib}:
/*
Recursively prepends a base path to all file paths in a source tree.

Example:
  sources = {
    foo.nix = true;
    bar = {
      baz.txt = true;
    };
  };

  collect "/my/base/path" sources
  => {
       foo.nix = "/my/base/path/path/to/foo.nix";
       bar = {
         baz.txt = "/my/base/path/path/to/bar/baz.txt";
       };
     }
  ```
*/
basePath: sources:
lib.attrsets.mapAttrsRecursive (keys: _: basePath + "/${builtins.concatStringsSep "/" keys}") sources
