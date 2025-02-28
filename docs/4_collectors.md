# Collectors

Collectors are Nix modules responsible for gathering specific configuration from different units and modules.
They simplify the process of aggregating this data into a unified result, which is then exposed as part of your flake's outputs.

## Purpose

Collectors address the challenge of combining configurations from multiple sources in a structured and manageable way.
They provide a consistent mechanism for collecting and aggregating data, reducing boilerplate code and improving maintainability.

## Built-in Collectors

Synergy provides several built-in collectors:

- `checks`:  Collects checks (e.g., tests, linters) defined in your modules.
- `devShells`: Collects development shell configurations.
- `formatter`: Collects code formatters.
- `lib`: Collects utility functions and libraries.
- `overlays`: Collects Nixpkgs overlays.
- `packages`: Collects package definitions.

## Customizing Collectors

You can customize the behavior of collectors by modifying the `config.synergy.export` option.
This option allows you to specify how collectors should expose their results.

## Next Steps

See [Flake output](./5_flake-output.md) for more detail
