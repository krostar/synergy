{
  pkgs,
  data,
  units,
  ...
}: let
  nixagoFiles = units.harmony.lib.nixago.makeAll {
    inherit pkgs;
    configs = [
      (units.harmony.lib.nixago.files.justfile data.${pkgs.system}.dev.just pkgs)
      (units.harmony.lib.nixago.files.editorconfig data.${pkgs.system}.dev.editorconfig pkgs)
      (units.harmony.lib.nixago.files.intellij-idea.file-watchers data.${pkgs.system}.dev.intellij-idea.file-watchers pkgs)
    ];
    log = false;
  };
in
  pkgs.mkShellNoCC
  {
    inherit (nixagoFiles) shellHook;
    nativeBuildInputs = with pkgs; [
      binsider
      go_1_23
      gotools
      govulncheck
      jq
      just
      nix-diff
      nix-tree
    ];
  }
