# Synergy

Synergy is a nix flake framework.

Its goal is to provide a set of rules (or constraints) that allow code maintainers to code in an organized way, ideally more maintainable than without using it.

Synergy is designed to simplify and streamline the process of configuring systems, development environments, and any other nix related projects using a modular approach.
It provides a structured way to organize and manage configurations, making them more maintainable, reusable, and scalable in growing projects.

Synergy encourages breaking down configurations into smaller, self-contained units. Each units then define modules (like packages, or dev shells, or nixos configurations, ...), or reuse / combine them from other units.

## Harmony

Harmony leverages Synergy's modular design to offer a convenient way to share and manage development tools and settings across multiple projects.
Instead of replicating these configurations in each individual project, Harmony exposes them so you can use it directly, or extend it based on your needs.
This simplifies maintenance, ensures consistency, and reduces boilerplate code.

### Example

```nix
# flake.nix
inputs.harmony.url = "github:krostar/synergy";
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
