{
  data,
  lib,
  pkgs,
  units,
  ...
}:
units.harmony.lib.just.mkRecipe "linters" "lint-editorconfig" {
  editorconfig-checker = let
    inherit (units.harmony.lib) nixago;
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.editorconfig-checker;
    inherit
      (nixago.make {
        inherit pkgs;
        file = nixago.files.editorconfig-checker;
        data = cfg.settings;
      })
      configFile
      ;
  in {
    inherit (cfg) enable;
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.editorconfig-checker} -config=${configFile} {{ FILES }}
    '';
  };
}
