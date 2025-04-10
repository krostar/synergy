{
  pkgs,
  data,
  units,
  ...
}: let
  nixagoFiles = units.harmony.lib.nixago.makeAll {
    inherit pkgs;
    configs = [
      (units.harmony.lib.nixago.files.editorconfig data.${pkgs.system}.dev.editorconfig pkgs)
      (units.harmony.lib.nixago.files.intellij-idea.file-watchers data.${pkgs.system}.dev.intellij-idea.file-watchers pkgs)
    ];
    log = false;
  };
in
  pkgs.mkShellNoCC
  {
    inherit (nixagoFiles) shellHook;

    nativeBuildInputs =
      (with units.harmony.packages; [
        lint-editorconfig
        lint-ghaction
        lint-nix
        lint-renovate
        lint-sh
        lint-yaml
        renovate-diff
        treefmt
      ])
      ++ (with pkgs; [
        jq
        nix-diff
        nix-tree
      ]);
  }
