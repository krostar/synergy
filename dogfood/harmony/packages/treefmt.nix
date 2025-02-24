{
  data,
  pkgs,
  unit,
  ...
}: let
  treefmt =
    (unit.lib.treefmt.eval {
      inherit pkgs;
      config = data.${pkgs.system}.dev.formatters.treefmt;
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
