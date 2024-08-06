{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    haumea,
    nixpkgs,
    ...
  }: let
    synergy = import ./src {
      inherit haumea;
      inherit (nixpkgs) lib;
    };
  in
    synergy.lib.mkFlake {
      inherit inputs;
      src = ./dogfood;
      eval = {synergy.export.lib = v: v.synergy;};
    };
}
