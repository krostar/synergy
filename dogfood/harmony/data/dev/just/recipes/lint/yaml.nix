{
  data,
  lib,
  pkgs,
  unit,
  ...
}: let
  inherit (unit.lib) nixago;
in
  unit.lib.just.mkRecipe "linters" "lint-yaml" {
    _yamllint = let
      cfg = data.${pkgs.system}.ci.linters.yamllint;

      inherit
        (nixago.make {
          inherit pkgs;
          file = nixago.files.yamllint;
          data = cfg.settings;
        })
        configFile
        ;
    in {
      inherit (cfg) enable;
      groups = ["yaml"];
      attributes = ["positional-arguments"];
      parameters = [''+FILES="."''];
      recipe = ''
        ${lib.meta.getExe pkgs.yamllint} -c ${configFile} "$@"
      '';
    };
  }
