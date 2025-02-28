# Parameters provided to loaded sources

This document describes the parameters that are provided to loaded sources.

## Parameters Overview

The following parameters are provided to loaded sources if they are functions:

- [`data`](#data): Combined data model from all modules and dependencies.
- [`deps`](#deps): Dependencies units found in the flake's inputs.
- [`flake`](#flake): Metadata and attributes of the current flake.
- [`lib`](#lib): The nixpkgs library.
- [`results`](#results): Evaluated results for all systems (and also result without any systems).
- [`synergy-lib`](#synergy-lib): The internal Synergy library
- [`unit`](#unit): Modules within the current unit.
- [`units`](#units): Modules across all units.

## Parameter Details

### data

**Description**: The `data` parameter provides access to the combined data model from all modules and their dependencies within the current system (systemless or systemized).
This allows you to share configuration data between modules, units, and even projects.

### deps

**Description**: The `deps` parameter provides access to the evaluated configuration and results from  other Synergy units defined in your flake's inputs.
This allows you to reuse and extend configurations from other units.

**Example**:

```nix
{
  pkgs,
  deps,
  ...
}:

/*
# deps.myflakeinput looks like this
  {
    dependencies = { ... };
    flake = { ... };
    result = { ... };
    results = { ... };
  }
*/
let
  flakeInputName = "myflakeinput";
  moduleName = "packages";
  unitName = "myunit";
  inherit (deps."${flakeInputName}".result."${moduleName}"."${unitName}") myPackage;
in
  pkgs.mkShell {
    nativeBuildInputs = [ myPackage ];
  }
```

### flake

**Description**: The `flake` parameter represents the current flake's metadata and attributes.
It is a reference to the flake's `self` attribute.

```nix
{
  inputs = { ... };
  narHash = "sha256-4o+/qd7pSaQbNyGS48uhueBKj5upP4pT8ZZMHE3wqNg=";
  outPath = "/nix/store/p0gs5i2fymszcma8hr0nyzndxy247qyc-source";
  outputs = { ... };
}
```

### lib

**Description**: The `lib` parameter provides access to the nixpkgs library.

```nix
{
  lib,
  ...
}:
  lib.attrsets.filterAttrsRecursive
```

### results

**Description**: The `results` parameter provides access to the evaluated results of all units, either systemless or systemized.
This allows you to access results for different systems.

```nix
{
  systemized = {
    aarch64-darwin = { ... };
    aarch64-linux = { ... };
    x86_64-darwin = { ... };
    x86_64-linux = { ... };
  };
  systemless = { ... };
}
```

### synergy-lib

**Description**: The `synergy-lib` parameter provides access to the internal Synergy library.

**Example**:

```nix
{
  synergy-lib,
  ...
}:
  synergy-lib.attrsets.liftAll;
```

### unit

**Description**: The `unit` parameter provides access to all modules within the *current* unit.
This allows modules within the same unit to have access to each others results.

**Example**:

```nix
{
  unit,
  ...
}:
  unit.packages.example;
```

### units

**Description**: The `units` parameter provides access to all modules across *all* units within the current Synergy project.

**Example**:

```nix
{
  units,
  ...
}:
  units.someUnit.packages.example;
```

## Next Steps

Read about [collectors](./4_collectors.md).
