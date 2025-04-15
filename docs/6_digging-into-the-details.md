# Digging into the details

Previous documentation explains how to use synergy, this one explains how it works.

Everything happen in the `./src/lib` directory (aka `synergy-lib`) and starts in the `modules` folder
(the `mkFlake` function is simply calling `./src/lib/modules/eval.nix`).

## Step 1: lib.modules.eval

The eval function calls `lib.evalModules`, which initialize the synergy collector.

```nix
  initial = lib.evalModules {
    specialArgs = {
      synergy-lib = root;
      inherit (mkResult) flake;
    };
    modules =
      collectors
      ++ [
        {
          _file = ./eval.nix;
          synergy = {inherit (mkResult) load;};
        }
        eval
      ];
  };
```

the most important thing to consider here is the `synergy = {inherit (mkResult) load;};` line.
To understand it, we need to step back a little and focus on the `mkResult` function.

## Step 2: lib.modules.mkResult

This function returns an attribute set containing a `flake` attribute, which is the flake's `self` parameter,
and a `load` attribute, which is a function that returns an attribute set with the following keys `dependencies`, `flake`, `result`, `results`.

To compute those attributes, the `load` function takes two arguments `config` and `pkgs`.

- `config` is the `lib.evalModules`'s `config` attribute
- `pkgs` is the system for which the loading is happening (can be `null` for systemless, or a system instantiated `nixpkgs`).

Those parameters are useful to call `lib.modules.load`, which basically loads the sources.

## Step 3: lib.modules.load

This function loads all sources and provides them with a set of arguments (better explained [here](./4_sources-parameters)):

- data: a global attribute set
- deps: synergy dependencies in the source's flake's inputs
- flake: some details about the source's flake
- lib: nixpkgs's lib
- results: per system, all units results
- synergy-lib: synergy's lib
- unit: the current unit's result
- units: all units results

the output of load is an attribute set of all units with keys being the unit, and loaded modules the values.

## Step 4: the synergy collector

Getting back to the `synergy.load` attribute above: this is the only required initialization of the synergy collector.

Based on that load function, the collector will have a `loaded` attribute, which is the result of calling `synergy.load` for each systems:

```nix
default = {
  systemless = cfg.load config null;
  systemized = lib.attrsets.genAttrs cfg.systems (system: (cfg.load config (cfg.mkPkgsForSystem system)));
};
```

you can see that using nix repl:

```
# outputs._synergy.config.synergy.loaded.systemized.aarch64-darwin
{
  dependencies = { ... };
  flake = { ... };
  result = { ... };
  results = { ... };
}
```

everything else is based on this `loaded` attribute.

## Next Steps

See [Troubleshooting](./7_troubleshooting.md).
