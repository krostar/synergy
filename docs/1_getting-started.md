# Getting Started with Synergy

This tutorial will walk you through setting up Synergy in a new project and creating your first organized modules.

## Prerequisites

- Nix with flakes enabled

## Step 1: initialize your project

Create a new directory for your project:

```bash
mkdir my-synergy-project
cd my-synergy-project
```

## Step 2: create your flake

Create a `flake.nix` file with Synergy:

```nix
# flake.nix
{
  description = "My project using Synergy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    synergy.url = "github:krostar/synergy";
  };

  outputs = {synergy, ...} @ inputs:
    synergy.lib.mkFlake {
      inherit inputs;
      src = ./nix;  # This is where we'll put our organized code
    };
}
```

## Step 3: create your source directory structure

Create the directory structure that Synergy will use:

```bash
mkdir -p nix/foo
mkdir -p nix/bar
```

## Step 4: create your first package

Let's create a simple package in the `foo` unit:

```nix
# nix/foo/packages/hello-world.nix
{pkgs, ...}: {
  pkgs.writeShellScriptBin "hello-world" ''
    echo "Hello from Synergy!"
  '';
}
```

## Step 5: create your first development environment

Now create a development environment that uses your package:

```nix
# nix/bar/devShell.nix
{pkgs, units, ...}:

pkgs.mkShellNoCC {
  nativeBuildInputs = [
    units.foo.packages.hello-world
  ];
}
```

## Step 6: test your setup

Now let's test that everything works:

```bash
# See what Synergy has automatically created
nix flake show

# Expected output:
# ├───devShells
# │   ├───aarch64-darwin
# │   │   ├───default: development environment
# │   └───x86_64-linux
# │       ├───default: development environment
# └───packages
#     ├───aarch64-darwin
#     │   ├───hello-world: package
#     └───x86_64-linux
#         ├───hello-world: package
```

## Step 8: try your packages

Build and run your packages:

```bash
# Build and run the hello world script
nix run .#hello-world

# Build and run the Python app
nix run .#my-python-app

# Build a package to see the result
nix build .#hello-world
./result/bin/hello-world
```

Enter your development environments:

```bash
# Enter the app development environment
nix develop .#
hello-world
exit
```

## Next step

Continue to [Loading Sources](./2_loading-sources.md) to learn more about how Synergy discovers and loads your modules.
