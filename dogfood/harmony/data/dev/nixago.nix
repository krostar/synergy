{
  units,
  data,
  pkgs,
  ...
}: {
  justfile = units.harmony.lib.nixago.files.justfile data.${pkgs.stdenv.hostPlatform.system}.dev.just pkgs;
  editorconfig = units.harmony.lib.nixago.files.editorconfig data.${pkgs.stdenv.hostPlatform.system}.dev.editorconfig pkgs;
}
