{lib, ...}:
/*
Runs a coverage test for the provided unit.

This test ensures that all parts of the unit are covered by tests.
It does this by checking if a test exists for each attribute path in the unit.

The `ignore` parameter can be used to ignore specific attributes.

If `strict` is set to `true`, the test will fail if coverage is not 100%.
Otherwise, the test will pass even if some parts of the unit are not covered.
*/
{
  pkgs, # nixpkgs instance to use.
  unit, # unit to test
  coverTestName ? "cover", # name of the coverage test
  ignore ? [], # list of attributes to ignore
  strict ? true, # wether to fail if coverage is not 100%
}: let
  checks = builtins.removeAttrs unit.checks [coverTestName];
  coverage =
    builtins.removeAttrs (builtins.listToAttrs (
      builtins.map (v: lib.attrsets.nameValuePair (lib.strings.concatStringsSep "." v) (lib.attrsets.hasAttrByPath v checks))
      (lib.attrsets.collect builtins.isList (
        lib.mapAttrsRecursiveCond (v: builtins.isAttrs v && !(lib.attrsets.isDerivation v)) (
          keys: _: keys
        ) (builtins.removeAttrs unit ["checks"])
      ))
    ))
    ignore;
in
  pkgs.runCommand "coverage" {
    nativeBuildInputs = with pkgs; [jq];
  } ''
    ${
      if lib.lists.any (v: !v) (builtins.attrValues coverage)
      then ''
        echo "Some parts of the current unit are not covered:" >&2
        (echo '${builtins.toJSON coverage}' | jq --sort-keys --raw-output 'to_entries[] | select(.value == false) | "- "+.key') >&2
        ${
          if strict
          then "exit 1"
          else "touch $out"
        }
      ''
      else ''touch $out''
    }
  ''
