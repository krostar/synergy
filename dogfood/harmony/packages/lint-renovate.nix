{
  unit,
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "lint-renovate";

  runtimeInputs = [unit.packages.renovate-diff pkgs.jq pkgs.renovate];
  checkPhase = "";

  text = ''
    renovate-config-validator

    diff="$(renovate-diff)"
    if [ "$diff" == "" ]; then
      exit 0
    fi

    echo "$diff" | jq -r '"[" + .plugin + "] " + .source + ": newer " + .updateType + " for " + .name + " " + .currentVersion + " -> " + .newVersion'
    exit 1
  '';
}
