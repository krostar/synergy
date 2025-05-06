{
  nixConfig = {
    extra-substituters = ["https://krostar.cachix.org"];
    extra-trusted-public-keys = ["krostar.cachix.org-1:IiHyA+RhYtespJQzidfoVh6y08S6f3sOzKD8M6vMNjw="];
  };

  inputs = {
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixago = {
      url = "github:nix-community/nixago";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixago-exts.follows = "nixago-exts";
      };
    };

    nixago-exts = {
      url = "github:nix-community/nixago-extensions";
      inputs = {
        flake-utils.follows = "nixago/flake-utils";
        nixago.follows = "nixago";
        nixpkgs.follows = "nixpkgs";
      };
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
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
      eval = {lib, ...}: {
        synergy.export = {
          lib = v: v.synergy;
          devShells = cfg: (builtins.mapAttrs (
              system: units:
                {inherit (cfg.${system}.repo) default;}
                // synergy.lib.attrsets.liftChildren "-" units
            )
            cfg);
          packages = cfg: (builtins.mapAttrs (
              system: units: (synergy.lib.attrsets.liftChildren "-" (builtins.mapAttrs (
                  _: packages: (lib.attrsets.filterAttrs (
                      name: _: !(lib.strings.hasSuffix "linux" system && name == "lorri-notifier")
                    )
                    packages)
                )
                units))
            )
            cfg);
        };
      };
    };
}
