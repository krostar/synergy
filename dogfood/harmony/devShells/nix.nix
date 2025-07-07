{
  pkgs,
  unit,
  ...
}:
pkgs.mkShellNoCC
{
  shellHook = unit.lib.nixago.appendToShellHooks pkgs "";
  nativeBuildInputs = with pkgs; [
    jq
    just
    nix-diff
    nix-tree
  ];
}
