{lib, ...}: data: pkgs: let
  output = ".justfile";
in {
  inherit data output;
  engine = builtins.import ./engine.nix {inherit lib pkgs;};
  apply = data: builtins.removeAttrs data ["enable"];
}
