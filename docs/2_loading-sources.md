# Loading sources in Synergy

Synergy automatically discovers and loads Nix files within the `src` directory you specify
in `synergy.lib.mkFlake`. It recursively traverses the `src` directory, looking for files
ending with `.nix`. It then `builtins.import` each of them and return them as an attribute set.

For each imported files, if they are functions, they are automatically called with [parameters provided to loaded sources](./3_sources-parameters.md).

## Loading rules

The source tree should look something like this: `./$SRC/$UNIT/$MODULE/$FILE.nix`.

- `$SRC` must be a directory
- `$UNIT` must be a directory, regular files are not loaded at `$SRC` depth
- `$MODULE` can be a directory or a regular nix file
- if `$MODULE` is a directory and does not contain a `default.nix` file, all the files and directories in that directory are recursively loaded
- for a file to be loaded it must be a regular files ending with `.nix`
- anything which name starts with a underscore (`_`) is not loaded
- below `$SRC`, if any file (without considering the `.nix` file extension) share the same name as a directory, only the file is loaded
- below `$SRC`, if a `default.nix` file is present at any depth, only that file is loaded, other files at that depth and descendants from that point onward won't be loaded

See [tests cases](../dogfood/synergy/checks/lib/modules/collect.nix) for a concrete example.

## Loading result

Loaded files are evaled, and result can be anything, often it is an attribute set.

## Next Steps

Read about [parameters provided to loaded sources](./3_sources-parameters.md).
