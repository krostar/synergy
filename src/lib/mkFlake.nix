{super}:
/*
Evaluates Synergy modules and returns only the flake output.

This is the main entry point for using Synergy in a flake. It wraps the
modules.eval function and extracts just the flake output from the result.

Parameters:
  - `args`: Configuration for Synergy evaluation
    - `inputs`: Flake inputs
    - `src`: Path to sources directory
    - `eval`: Optional inline configuration
    - `collectors`: Optional list of collectors to use

Returns:
  The flake outputs attribute set ready to be returned from a flake's outputs function

Example:
  ```nix
  outputs = {synergy,...}@inputs: {
    inherit (synergy.lib.mkFlake {
      inherit inputs;
      src = ./nix;
    });
  };
  ```
*/
args: (super.modules.eval args).config.flake
