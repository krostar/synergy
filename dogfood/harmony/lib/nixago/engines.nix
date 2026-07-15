{lib, ...}: pkgs: {
  cue = import ./_core/engines/cue.nix {inherit pkgs lib;};
  nix = import ./_core/engines/nix.nix {inherit pkgs lib;};
}
