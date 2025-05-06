{pkgs, ...}:
pkgs.writeShellApplication {
  name = "renovate-diff";

  runtimeInputs = [
    pkgs.jq
    pkgs.renovate
    pkgs.gnused
  ];
  checkPhase = "";

  text = ''
    if [ "$#" -ne 0 ]; then
      >&2 echo "This script takes no arguments."
      exit 1
    fi

    # if GITHUB_COM_TOKEN is defined, do nothing
    # otherwise try to fill it based on GITHUB_TOKEN_FILE content
    if [[ -z "''${GITHUB_COM_TOKEN:-}" && -n "''${GITHUB_TOKEN_FILE:-}" && -f "$GITHUB_TOKEN_FILE" ]]; then
      GITHUB_COM_TOKEN="$(tr -d '[:space:]' < "$GITHUB_TOKEN_FILE")"
    else
      GITHUB_COM_TOKEN=""
    fi

    # Export GITHUB_COM_TOKEN if it's not empty
    if [[ -n "$GITHUB_COM_TOKEN" ]]; then
      export GITHUB_COM_TOKEN
    fi

    export LOG_LEVEL="debug"

    if ! OUTPUT=$(renovate --platform=local 2>&1); then
      echo "$OUTPUT"
      exit 3
    fi

    # renovate prints all sort of debug information, part of it are the updates we are looking for
    # first sed removes all lines except the one containing the updates in a nearly valid json
    # second sed replaces "config: {" with only "{" so json is valid
    # then jq simplifies the output
    echo "$OUTPUT" \
      | sed -n '/DEBUG: packageFiles with updates (repository=local)/,/DEBUG: detectSemanticCommits() (repository=local)/{//!p;}' \
      | sed '1s/.*/{/' \
      | jq '. | to_entries[] | {
            plugin:.key
        } + (
            .value[] | {
                source: .packageFile
            } + (
                .deps[] | select((.updates | length) > 0) | {
                    name: .depName,
                    pkg: .packageName,
                    currentVersion: (.currentVersion // .currentDigest),
                } + (
                    .updates[] | {
                        newVersion: (.newVersion // .newDigest),
                        updateType: .updateType,
                    }
                )
            )
        )'
  '';
}
