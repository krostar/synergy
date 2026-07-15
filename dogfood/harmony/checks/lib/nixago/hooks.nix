/*
Behavior tests for the generated hook scripts, exercised in a sandboxed git
repository: link mode (symlink creation, .gitignore management, idempotence,
refusal to overwrite regular files) and copy mode (creation, refresh on
content change).
*/
{
  pkgs,
  unit,
  ...
}: let
  mkRequest = mode: {
    data.hello = "world";
    output = "sub/dir/test.json";
    hook.mode = mode;
  };

  linkMade = unit.lib.nixago.make {
    inherit pkgs;
    config = mkRequest "link";
    log = false;
  };

  copyMade = unit.lib.nixago.make {
    inherit pkgs;
    config = mkRequest "copy";
    log = false;
  };
in
  pkgs.runCommand "lib-nixago-hooks" {nativeBuildInputs = [pkgs.git];} ''
    export HOME="$TMPDIR"

    # --- link mode ---
    mkdir link-repo && cd link-repo && git init -q

    ${linkMade.install}/bin/nixago_shell_hook
    [[ $(readlink sub/dir/test.json) == ${linkMade.configFile} ]]
    grep -qF 'nixago: ignore-linked-files' .gitignore
    grep -qF '/sub/dir/test.json' .gitignore

    # second run is idempotent: same link target, no duplicate gitignore entry
    ${linkMade.install}/bin/nixago_shell_hook
    [[ $(readlink sub/dir/test.json) == ${linkMade.configFile} ]]
    [[ $(grep -cF '/sub/dir/test.json' .gitignore) -eq 1 ]]

    # refuses to overwrite a pre-existing regular file
    rm sub/dir/test.json
    echo existing-content > sub/dir/test.json
    ${linkMade.install}/bin/nixago_shell_hook
    [[ $(cat sub/dir/test.json) == existing-content ]]

    # --- copy mode ---
    cd .. && mkdir copy-repo && cd copy-repo && git init -q

    ${copyMade.install}/bin/nixago_shell_hook
    [[ ! -L sub/dir/test.json ]]
    cmp ${copyMade.configFile} sub/dir/test.json

    # tampered copies are refreshed
    echo tampered > sub/dir/test.json
    ${copyMade.install}/bin/nixago_shell_hook
    cmp ${copyMade.configFile} sub/dir/test.json

    touch $out
  ''
