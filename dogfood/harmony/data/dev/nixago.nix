{
  units,
  data,
  pkgs,
  ...
}: {
  justfile = units.harmony.lib.nixago.files.justfile data.${pkgs.system}.dev.just pkgs;
  editorconfig = units.harmony.lib.nixago.files.editorconfig data.${pkgs.system}.dev.editorconfig pkgs;
}
