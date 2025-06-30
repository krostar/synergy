# Module Parameters: what's available in your modules

When Synergy loads your modules, it automatically provides a set of parameters that give you access to all units, modules, configuration data, and more. This guide shows you exactly what's available and how to use each parameter.

## Overview

Every Synergy module function receives these parameters:

```nix
{
  # Core Nix ecosystem
  lib,           # nixpkgs library functions
  pkgs,          # nixpkgs packages (for systemized modules only)

  # Dependending on your project
  data,          # Shared configuration data
  unit,          # Other modules in the same unit
  units,         # Modules from all units in your project

  # External dependencies
  deps,          # Synergy modules from other projects

  # For advanced use-cases
  flake,         # Details about your flake
  results,       # All evaluated results
  synergy-lib,   # Synergy's internal utilities
}: {}
```

## Core parameters

### `lib` - nixpkgs library functions

The standard nixpkgs library with all the utility functions you're used to.

### `pkgs` - nixpkgs packages

The nixpkgs package set for the current system.

Modules are either systemized or systemless, its defined by which result the collector is using.

**Note:** pkgs is only available in systemized modules (like `packages`, `devShells`). Not available in systemless modules (like `lib`).

## Project structure parameters

### `data` - shared configuration data

A global configuration space where modules can share data, settings, and coordination information. Perfect for configuration that needs to be consistent across modules, even across projects.

The data parameter comes from the systemized data module.
All loaded units in the project can impact the data module (so can external dependencies).

This is particularly useful to strongly define configuration and override it when needed.

The module data is collected during evaluation, as other regular modules, but is re-injected as a parameter for all modules ; watch out for infinite recursion when using it.

### `unit` - same unit modules

Access other modules within the same unit.

**Example structure:**

```
src/
└── backend/
    ├── packages.nix
    ├── devShells.nix
    └── checks.nix
```

**Usage:**

For example, the devShells module can reference packages using `unit.packages.mypkg`.

### `units` - all project modules

Access modules from any unit in your project. Great for sharing utilities, reusing packages, or creating composed solutions.

**Example structure:**

```
src/
├── backend/
│   └── packages.nix
├── frontend/
    └── packages.nix
    └── devShells.nix
```

**Usage:**

Here the devShells module can reference the frontend packages using `unit.packages.mypkg`,
but also the backend packages using `units.backend.packages.mypkg`.

## External dependencies

### `deps` - external synergy projects

Access modules from other Synergy-based projects listed in your flake inputs. This enables powerful composition and reuse across projects.

**Flake setup:**

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    synergy.url = "github:krostar/synergy";

    mycompanysharedstuff = {
      url = "github:myorg/stuff";
      inputs.synergy.follows = "synergy";
    };
  };

  outputs = {synergy, ...} @ inputs:
    synergy.lib.mkFlake {
      inherit inputs; # dependencies will be detected automatically from inputs
      src = ./nix;
    };
}
```

**Usage:**

Say the `mycompanysharedstuff` input exposes a unit "sre" with a devShells module called "nix" ;
then one could re-use (or even extend it) using `deps.mycompanysharedstuff.result.devShells.sre.nix`.

```nix
# nix/web/devShells.nix
{
  pkgs,
  deps,
  ...
}:
deps.mycompanysharedstuff.result.devShells.sre.nix.overrideAttrs (_: prev: {
  nativeBuildInputs =
    prev.nativeBuildInputs
    ++ (with pkgs; [
      mkpasswd
      sops
    ]);
})
```

## Next Steps

Now that you understand what parameters are available in your modules, learn about [Collectors](./4_collectors-and-flake-outputs.md) to understand how Synergy aggregates your modules into flake outputs.
