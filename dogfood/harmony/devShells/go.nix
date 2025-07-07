{
  pkgs,
  unit,
  ...
}:
pkgs.mkShellNoCC
{
  shellHook = unit.lib.nixago.appendToShellHooks pkgs "";
  nativeBuildInputs = with pkgs; [
    binsider
    go_1_24
    gotools
    govulncheck
    jq
    just
    nix-diff
    nix-tree
  ];
}
