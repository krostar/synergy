# Getting Started with Synergy

This guide provides instructions on setting up and using Synergy in your Nix flake.

## Update your flake

1. **Add Synergy as an Input**:

```nix
inputs.synergy.url = "github:krostar/synergy";
```

2. **Instantiate Synergy**:

```nix
outputs = {synergy,...}@inputs: {
  inherit (synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix; # path to your nix source code
  });
};
```

## Next Steps

Read about [Loading Sources](./2_loading-sources.md).
