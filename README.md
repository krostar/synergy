# Synergy

**A modular Nix flake framework that makes your projects more organized, maintainable, and reusable.**

Synergy transforms how you structure Nix projects by breaking them into small, focused units and modules. Instead of monolithic configurations, you get clean separation of concerns, easy reusability across projects, and a scalable architecture that grows with your needs.

## Why Synergy?

**Before Synergy:** Large, unwieldy flake.nix files with everything mixed together. No clear project structure.

**With Synergy:** Clean, modular structure where packages, dev shells, configurations, ... are organized into logical units. Easy reuse across projects. Consistent patterns everywhere.

## Core Concepts

### Units

**Logical groupings** of related functionality that organize your project into cohesive, manageable pieces. Units represent bounded contexts or feature areas within your codebase, similar to how you might organize code into different services, applications, or functional domains.

Each unit contains its own set of modules and can be developed, tested, and reasoned about independently while still being able to reference and build upon other units.

**Examples:**

- `backend`/`frontend` - for a stack-based split
- `shared` - Common libraries, utilities, base configurations
- `homelab` - Personal server configurations and services
- `mycompany` - Organization-specific tools and standards
- ...

Choose unit names that make sense for your project's architecture and team structure.

### Modules

**Specific configurations** within a unit. Each module type serves a different purpose and corresponds to standard Nix flake outputs.

- `packages` - Package definitions and derivations
- `devShells` - Development environments and tooling
- ...

Modules can define any type of output, but they're most powerful when used (collected) by collectors to construct flake outputs. The specific modules that get collected depend on which collectors are configured.

### Collectors

**Automated output generation** that gathers modules of the same type across all units and transforms them into flake outputs.

Collectors eliminate the tedious manual work of wiring up your modules. They automatically discover all modules of each type throughout your project structure and seamlessly combine them into the expected flake outputs that tools like `nix build`, `nix develop`, and `nix run` expect.

- All `packages` modules across units → `packages` flake output
- All `devShells` modules across units → `devShells` flake output
- And so on for any module type you define

The beauty is in the automation: add a new file in a package folder in your project, and it's immediately available as `nix build .#unit-name.package-name` without any manual configuration.

## Example

See the dogfood folder, it uses synergy to define the harmony unit, and check itself.

## Module Communication

Modules can reference each other for powerful composition:

```nix
# nix/frontend/devShell.nix
{pkgs, unit, units, ...}:
pkgs.mkShell {
  nativeBuildInputs = [
    unit.packages.web-app           # Same unit
    units.backend.packages.api-cli  # Different unit
    units.shared.lib.deploy-script  # Shared utilities
  ];
}
```

## Working with Dependencies

Reuse Synergy modules from other projects:

```nix
# flake.nix
inputs = {
  synergy.url = "github:krostar/synergy";
  awesomeproject = {
    url = "github:myorg/mylib";
    inputs.synergy.follows = "synergy";
  };
};

outputs = {synergy, ...} @ inputs:
  synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix;
  };
```

```nix
{pkgs, deps, ...}:
pkgs.mkShell {
  nativeBuildInputs = [
      deps.awesomeproject.result.packages.backend.awesome-api
  ];
}
```

## What You Get

- ✅ **Automatic flake outputs:** No manual wiring needed
- ✅ **Cross-references:** Modules can easily use each other
- ✅ **Dependency management:** Import modules from other Synergy projects
- ✅ **Consistent structure:** Same patterns across all projects

## Documentation

- **[Getting Started](./docs/1_getting-started.md)**
- **[Loading Sources](./docs/2_loading-sources.md)**
- **[Module Parameters](./docs/3_module-parameters.md)**
- **[Collectors and Outputs](./docs/4_collectors-and-outputs.md)**

## Harmony

**Ready-to-use development tools and configurations.**

Harmony is a Synergy-based project that provides opiniatred development tools, linters, formatters, and configurations. You can use synergy without harmony.

## Story behind the project

When I discovered Nix, I quickly realized that GitHub would be my best ally for learning from others' contributions. What I found while browsing projects was a striking lack of standardization. At first, this didn't seem like a big deal—until I discovered flakes: a single entry point that explicitly defines dependencies and exposes standardized outputs. The promise was clear, yet every flake project still looked completely different.

As a beginner, it wasn't always smooth reading trying to make sense of various `flake.nix` files. When I started writing my own Nix code, I quickly discovered the truth: keeping flakes simple while maintaining project discoverability is genuinely hard. Questions started piling up: How do you test things properly? How do you propagate nixpkgs overlays cleanly? What is the best way to provide the nixpkgs instanciation everywhere ?

The more Nix code I wrote, the more I found myself wondering: "Would the nix community understand this and think it is nix-idomatic ? What would onboarding look like if I work with someone else on this project?"

As the projects grew, I began organizing things where they seemed to make the most sense: packages in a `packages/` directory, NixOS configurations in a `nixosConfigurations/` directory, writing small helpers to easily load things. But reusing components without passing crazy parameters everywhere quickly became messy.

In my quest for standardization, I discovered [flake-parts](https://flake.parts/), [std](https://github.com/divnix/std), and [hive](https://github.com/divnix/hive). I used these projects for a while—I like the idea behind those projects, and I don't really have anything negative to say about them, but they never quite clicked for me.

So here I am with Synergy: my humble attempt at finding peace in Nix projects.
![https://xkcd.com/927/](https://imgs.xkcd.com/comics/standards.png)
