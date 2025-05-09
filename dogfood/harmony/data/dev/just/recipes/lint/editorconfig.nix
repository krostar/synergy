{
  data,
  lib,
  pkgs,
  unit,
  ...
}:
unit.lib.just.mkRecipe "linters" "lint-editorconfig" {
  editorconfig-checker = let
    inherit (unit.lib) nixago;
    cfg = data.${pkgs.system}.ci.linters.editorconfig-checker;
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
