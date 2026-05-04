{
  data,
  lib,
  pkgs,
  units,
  ...
}: let
  inherit (units.harmony.lib) nixago;
in
  units.harmony.lib.just.mkRecipe "linters" "lint-go" rec {
    golangci-lint = let
      cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.golangci-lint;
      inherit
        (nixago.make {
          inherit pkgs;
          file = nixago.files.golangci-lint;
          data = builtins.removeAttrs cfg ["enable"];
        })
        configFile
        ;
    in {
      inherit (cfg) enable;
      groups = ["go"];
      parameters = [''+PACKAGES="./..."''];
      recipe = ''
        ${lib.meta.getExe pkgs.golangci-lint} run --config ${configFile} --verbose {{ PACKAGES }}
      '';
    };

    govulncheck = {
      inherit (golangci-lint) enable;
      groups = ["go"];
      parameters = [''+PACKAGES="./..."''];
      recipe = ''
        ${lib.meta.getExe pkgs.govulncheck} {{ PACKAGES }}
      '';
    };
  }
