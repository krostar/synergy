{
  pkgs,
  unit,
  ...
}:
pkgs.mkShellNoCC
{
  shellHook =
    (unit.lib.nixago.appendToShellHooks pkgs "")
    + ''
      export PRJ_ROOT="$(git rev-parse --show-toplevel)"
    '';

  nativeBuildInputs = with pkgs; [
    jq
    just
  ];
}
