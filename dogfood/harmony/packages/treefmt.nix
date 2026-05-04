{
  data,
  pkgs,
  unit,
  ...
}: let
  treefmt =
    (unit.lib.treefmt.eval {
      inherit pkgs;
      config = builtins.removeAttrs data.${pkgs.stdenv.hostPlatform.system}.dev.formatters.treefmt ["enable"];
    })
    .config;
in
  pkgs.writeShellApplication {
    name = "treefmt";

    runtimeInputs = [treefmt.package];
    checkPhase = "";

    text = ''
      tofmt=(".")
      if [ "$#" -ne 0 ]; then
        tofmt=("$@")
      fi

      treefmt                                       \
        --config-file=${treefmt.build.configFile}   \
        --tree-root-file=${treefmt.projectRootFile} \
        "''${tofmt[@]}"
    '';
  }
