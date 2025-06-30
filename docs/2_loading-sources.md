# How Synergy loads your sources

Synergy automatically discovers and loads your Nix files. This guide explains exactly how it works with examples.

## The big picture

Synergy transforms your organized source directory into a structured attribute set can use. Here's the transformation:

```
Your files                  →   What Synergy creates
src/                        →   {
├── backend/                →     backend = {
│   ├── packages.nix        →       packages = <loaded content>;
│   └── devShells.nix       →       devShells = <loaded content>;
├── frontend/               →     frontend = {
│   ├── packages/           →       packages = {
│   │   ├── web.nix         →         web = <loaded content>;
│   │   └── mobile.nix      →         mobile = <loaded content>;
│   └── devShells.nix       →       devShells = <loaded content>;
└── shared/                 →     shared = {
    └── lib.nix             →       lib = <loaded content>;
                            →     };
                            →   }
```

## Overall rules

Flake-related rules applies, especially those related to git (ie: don't forget to git add your files).

### units must be directories

At the top level under your `src` directory, only directories are loaded as units. Files are ignored.

```
✅ Good - These become units:
src/
├── backend/        # ✅ Unit: backend
├── frontend/       # ✅ Unit: frontend
└── shared/         # ✅ Unit: shared

❌ Ignored - Files at src level:
src/
├── backend/        # ✅ Unit: backend
├── frontend/       # ✅ Unit: frontend
├── ignored.nix     # ❌ Ignored (file at src level)
└── README.md       # ❌ Ignored (not .nix file)
```

### Rule 2: modules can be files or directories

Inside units, modules can be either regular `.nix` files or directories:

```
✅ Both of these work:
backend/
├── devShells.nix  # ✅ Module: devShells (file)
└── packages/      # ✅ Module: packages (directory)
    ├── api.nix
    └── worker.nix
```

### Rule 3: only regular .nix files are loaded

Synergy only loads files ending with `.nix`:

```
✅ Loaded:
backend/
├── packages.nix    # ✅ Loaded
├── devShells.nix   # ✅ Loaded
└── lib/debug.nix   # ✅ Loaded

❌ Ignored:
backend/
└── script.sh       # ❌ Ignored (not .nix)
└── symlink.nix     # ❌ Ignored (not regular file)
```

## Directory loading rules

When a module is a directory, all `.nix` files inside are loaded recursively:

```
Source:                       Result:
frontend/                     frontend = {
├── packages/                   packages = {
│   ├── web/                      web = {
│   ├──── app.nix      →            app = <content of app.nix>;
│   │                             };
│   ├── mobile.nix     →          mobile = <content of mobile.nix>;
│   └── desktop.nix    →          desktop = <content of desktop.nix>;
                                };
                              };
```

Directories can be nested arbitrarily deep.

### The "default.nix" special case

If a directory contains `default.nix`, **only** that file is loaded. All other files and directories in that directory are ignored:

```
Source:                       Result:
frontend/                     frontend = {
├── packages/                   packages = <content of default.nix only>;
│   ├── default.nix    →      };
│   ├── web/app.nix    ❌ Ignored (default.nix takes precedence)
│   └── mobile.nix     ❌ Ignored (default.nix takes precedence)
```

See `synergy-lib.autoimport` to manually import file in default.nix.

### File vs directory precedence

If both a file and directory have the same name, only the file is loaded:

```
Source:
backend/
├── packages.nix       ✅ Loaded
└── packages/          ❌ Ignored (file takes precedence)
    └── api.nix
```

## Underscore naming rule

Anything starting with underscore (`_`) is ignored:

```
src/
├── _helpers/           # ❌ Ignored (starts with _)
└── backend/
    ├── devShells.nix   # ✅ Loaded
    ├── packages.nix    # ✅ Loaded
    ├── _private.nix    # ❌ Ignored (starts with _)
    └── _temp/          # ❌ Ignored (starts with _)
        └── test.nix
```

## Function vs attribute set loading

Once Synergy loads a file, it checks if the result is a function:

- **If it's a function**: calls it with [module parameters](./3_module-parameters.md) (like `pkgs`, `lib`, `unit`, etc.)
- **If it's not a function**: uses the value as-is

```nix
# This file exports a function - Synergy will call it
{pkgs, lib, ...}: {
  hello = pkgs.writeShellScriptBin "hello" "echo hello";
}

# This file exports a value - Synergy uses it directly
{
  greeting = "Hello World";
  version = "1.0.0";
}
```

## Testing

You can see exactly what Synergy loaded using the `_synergy` attribute:

```bash
# See what files were collected
nix eval .#_synergy.config.synergy.loaded.systemless.sources --json | jq .
```

## Next Steps

Now that you understand how Synergy loads your sources, learn about [Module Parameters](./3_module-parameters.md) to understand what's available in your loaded modules.
