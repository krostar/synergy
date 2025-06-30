# Collectors and flake outputs: from modules to flake results

Collectors are Synergy's key piece that transforms your organized modules into clean, usable flake outputs. This guide explains how collectors work, what outputs they create, and how to use and customize everything.

## The big picture: collectors create outputs

Synergy's collectors automatically find, gather, and expose your modules as standard Nix flake outputs.

In other words, collectors are *nix modules* that collects some *synergy modules* results, transform, and expose them as *flake outputs*.

## Built-in collectors and their outputs

The goal of those collectors is to map to the official flake schema.

### `checks`

**Collects:** `checks`
**Systemized:** yes
**Outputs:** `checks.<system>.<check-name>`

### `devShells`

**Collects:** `devShells`
**Systemized:** yes
**Outputs:** `devShells.<system>.<unit-name>`

### `formatter` - code formatting

**Collects:** `formatter`
**Systemized:** yes
**Outputs:** `formatter.<system>`

### `lib`

**Collects:** `lib`
**Systemized:** no
**Outputs:** `lib.<function-name>`

### `overlays`

**Collects:** `overlays`
**Systemized:** no
**Outputs:** `overlays.<overlay-name>`
**Note:** overlays are automatically applied when instanciating nixpkgs to obtain pkgs

### `packages`

**Collects:** `packages`
**Systemized:** yes
**Outputs:** `packages.<system>.<package-name>`

## Other collectors

When you import synergy, you can also enable harmony.
Harmony defines opiniatred, not especially official flake outputs:

- `darwinConfigurations` and `darwinModules` for nix-darwin configurations
- `diskoConfigurations` for disko configurations
- `homeConfigurations` for home-manager configurations
- `nixago` for nixago generators
- `nixosConfigurations` and `nixosModules` for nixos configurations

## Customization

You can chose which collectors to use, and define your own.
When loading synergy, use the `collectors` attribute to provide your own list.

## Debugging collectors and outputs

`nix repl` is your best ally.

```bash
nix-repl> :lf .#              # load your flake
outputs._synergy.config       # all collectors options
outputs._synergy.config.synergy.result.systemized.SYSTEM.MODULE.UNIT
```
