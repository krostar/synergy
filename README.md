# Synergy

Synergy is a Nix flake framework designed to enhance code organization, maintainability,
and reusability in Nix projects. It promotes a modular approach, encouraging you to
break down configurations into smaller, self-contained units that define or combine modules
(packages, dev shells, NixOS configurations, etc.).

## Benefits

- **Improved Organization:** Structured project layout for better maintainability.
- **Increased Reusability:** Modular design allows easy reuse of configurations across projects.
- **Reduced Boilerplate:** Avoid repetitive code.
- **Scalability:** Easier to manage and extend configurations as projects grow.
- **Consistency:** Helps providing consistent configurations across different environments.

## Key Concepts

- **Units:** Logical groupings of modules, often representing a specific component or feature.
- **Modules:** Reusable configurations for packages, development environments, or system settings.
- **Collectors:** Nix modules that gather and aggregate configuration data from different units and modules, simplifying the creation of unified flake outputs.

## Getting started

See the [Getting Started](./docs/1_getting-started.md) guide for detailed instructions on setting up Synergy in your project. Here's a quick overview:

1. **Setup your flake:**

```nix
# flake.nix
inputs.synergy.url = "github:krostar/synergy";

outputs = {synergy,...}@inputs: {
  inherit (synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix;
  });
};
```

- `src`: Specifies the directory containing your units and modules (e.g., `./nix`). See [Loading Sources](./docs/2_loading-sources.md) for more details.
- `inputs`: Provides the flake's inputs to Synergy.

1. **Organize Your Source Code:** Structure your project into units and modules within the `src` directory.

```
nix/
  unitA/
    moduleA/
      file1.nix
      file2.nix
    moduleB.nix
  unitB/
    moduleB.nix
```

This example defines two units (`unitA`, `unitB`). `unitA` contains two modules (`moduleA`, `moduleB`), and `unitB` contains one module (`moduleB`).

## Understanding Synergy's core mechanics

- **Loading Sources:** Synergy recursively loads all Nix files within the `src` directory. See [Loading Sources](./docs/2_loading-sources.md) for details on the loading process.

- **Collectors:** Collectors aggregate configuration data from units and modules to generate flake outputs. See the [Collectors](./docs/4_collectors.md) documentation for details on available collectors and how to create new ones.

- **The `_synergy` Attribute:** Synergy adds a `_synergy` attribute to your flake outputs, providing access to the internal configuration and loading mechanism.

## Working with external dependencies

If you want to use synergy modules defined in project A, like a package named `mypkg` defined in a unit named `myunit`, in a different project B:

```nix
# flake.nix
inputs = {
  synergy.url = "github:krostar/synergy";
  projectA = {
    url = "github:example/projectA";
    inputs.synergy.follows = "synergy";
  }
}

outputs = {synergy,...}@inputs: {
  inherit (synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix;
  });
};
```

```nix
# nix/repo/devShell.nix
{
  pkgs,
  deps,
  ...
}:
  pkgs.mkShellNoCC {
    nativeBuildInputs = deps.projectB.result.packages.myunit.mypkg;
  }
```

## Further Reading

See `./docs/*.md`.

## Harmony

Harmony leverages Synergy's modular design to offer a convenient way to share and manage development tools and settings across multiple projects.
Instead of replicating these configurations in each individual project, Harmony exposes them so you can use it directly, or extend it based on your needs.
This simplifies maintenance, ensures consistency, and reduces boilerplate code.

### Example

```nix
# flake.nix
inputs.synergy.url = "github:krostar/synergy";
outputs = inputs @ {synergy,...}: {
  synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix;
    eval.synergy.restrictDependenciesUnits.synergy = ["harmony"];
  };
}
```

```nix
# nix/repo/devShell.nix
{
  pkgs,
  deps,
  ...
}:
deps.harmony.result.devShells.harmony.go.overrideAttrs (_: prev: {
  nativeBuildInputs = prev.nativeBuildInputs ++ (with pkgs; [http-server]);
})
```

```nix
# nix/repo/data.nix
{
  ci.linters.yamllint.ignore = [./custom-file-to-ignore.yaml];
}
```
