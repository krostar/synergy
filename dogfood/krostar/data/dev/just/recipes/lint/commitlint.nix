{
  lib,
  data,
  units,
  pkgs,
  ...
}: let
  inherit (units.harmony.lib) nixago;
in
  units.harmony.lib.just.mkRecipe "linters" "lint-commit" {
    commitlint = let
      cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.commitlint;

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
      recipe = "${lib.meta.getExe units.harmony.packages.commitlint} --config ${configFile} --strict --last";
    };
  }
