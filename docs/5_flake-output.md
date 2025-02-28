# Flake outputs

Synergy uses collectors to gather configuration data from different units and modules and expose it as part of the flake's outputs.

The default collectors expose the following attributes:

- `checks`: Checks (e.g., tests, linters)
- `devShells`: Development shell configurations
- `formatter`: Code formatters
- `lib`: Utility functions and libraries
- `overlays`: Nixpkgs overlays
- `packages`: Package definitions

You can customize which collectors are enabled and how they expose their results using the `synergy.export`.

## Customizing Export Behavior

The `config.synergy.export` option allows you to specify how collectors should expose their results.
It's an attribute set where keys are collector names and values are functions that take the collector's result as input and return the desired output.

```nix
synergy.lib.mkFlake {
  #...
  eval.synergy.export = {
    devShells = cfg: (builtins.mapAttrs (
      system: units:
        {inherit (cfg.${system}.repo) default;} # keep repo "default" unit shell as flake's default
        // synergy.lib.attrsets.liftChildren "-" units # all other shells, expose them like $UNIT-$name
    ) cfg);
  };
};
```

## Next Steps

See [Digging into the details](./6_digging-into-the-details.md) for more detail
