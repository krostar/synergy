{
  lib,
  data,
  unit,
  pkgs,
  ...
}: let
  inherit (unit.lib) nixago;
in
  unit.lib.just.mkRecipe "linters" "lint-commit" {
    commitlint = let
      cfg = data.${pkgs.system}.ci.linters.commitlint;

      inherit
        (nixago.make {
          inherit pkgs;
          file = nixago.files.commitlint;
          data = cfg.settings;
        })
        configFile
        ;
    in {
      inherit (cfg) enable;
      recipe = "${lib.meta.getExe unit.packages.commitlint} --config ${configFile} --last";
    };
  }
