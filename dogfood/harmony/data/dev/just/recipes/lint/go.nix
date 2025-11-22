{
  data,
  lib,
  pkgs,
  unit,
  ...
}: let
  inherit (unit.lib) nixago;
in
  unit.lib.just.mkRecipe "linters" "lint-go" rec {
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
      parameters = ["*PACKAGES"];
      recipe = ''
        ${lib.meta.getExe pkgs.golangci-lint} run --config ${configFile} --verbose {{ if PACKAGES == "" { "./..." } else { PACKAGES } }}
      '';
    };

    govulncheck = {
      inherit (golangci-lint) enable;
      groups = ["go"];
      parameters = ["*PACKAGES"];
      recipe = ''
        ${lib.meta.getExe pkgs.govulncheck} {{ if PACKAGES == "" { "./..." } else { PACKAGES } }}
      '';
    };
  }
