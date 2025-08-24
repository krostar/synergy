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
      export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    '';

  nativeBuildInputs = with pkgs; [
    jq
    just
  ];
}
