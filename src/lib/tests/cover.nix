{lib}:
# Runs a coverage test for the provided unit.
#
# This function creates a comprehensive test coverage verification system that
# ensures all parts of a Synergy unit are adequately tested. It performs static
# analysis of the unit structure to identify all testable components and then
# verifies that corresponding test cases exist.
#
# The coverage analysis process:
# 1. Unit Structure Analysis - Recursively explores the unit to find all attributes
# 2. Test Discovery - Examines the unit.checks attribute for existing tests
# 3. Coverage Mapping - Maps each unit attribute to its corresponding test
# 4. Gap Analysis - Identifies attributes that lack test coverage
# 5. Report Generation - Creates detailed coverage reports with missing items
# 6. Enforcement - Optionally fails the build based on coverage requirements
#
# Examples: see ./dogfood/synergy/checks/cover.nix
{
  pkgs, # nixpkgs instance
  unit, # synergy unit to analyze - must contain testable attributes and checks
  coverTestName ? "cover", # name of this coverage test to exclude from self-analysis
  ignore ? [], # list of dot-notation attribute paths to exclude from coverage requirements
  strict ? true, # whether to fail the build on incomplete coverage (true) or just warn (false)
}: let
  # extract all existing test cases from the unit, excluding the coverage test itself
  # this prevents the coverage analysis from trying to find a test for itself
  checks = builtins.removeAttrs unit.checks [coverTestName];

  coverage =
    builtins.removeAttrs (
      builtins.listToAttrs (
        builtins.map (
          attributePath:
            lib.attrsets.nameValuePair
            (lib.strings.concatStringsSep "." attributePath)
            (lib.attrsets.hasAttrByPath attributePath checks)
        )
        (lib.attrsets.collect builtins.isList (
          lib.mapAttrsRecursiveCond
          (value: builtins.isAttrs value && !(lib.attrsets.isDerivation value))
          (keys: _: keys)
          (builtins.removeAttrs unit ["checks"])
        ))
      )
    )
    ignore;

  extra =
    lib.attrsets.collect
    (v: builtins.isString v && !(builtins.hasAttr v coverage))
    (
      lib.mapAttrsRecursiveCond
      (value: builtins.isAttrs value && !(lib.attrsets.isDerivation value))
      (keys: _: lib.strings.concatStringsSep "." keys)
      checks
    );

  haveExtra = builtins.length extra > 0;
  isMissingCoverage = lib.lists.any (coverageStatus: !coverageStatus) (builtins.attrValues coverage);
in
  pkgs.runCommand "coverage" {
    nativeBuildInputs = with pkgs; [jq];
  } ''
    ${
      if haveExtra
      then ''
        echo "Some checks are covering non-existing unit module parts" >&2
        (echo '${builtins.toJSON extra}' | jq --sort-keys --raw-output '.[] | "- " + (. | tostring)') >&2
      ''
      else ""
    }${
      if isMissingCoverage
      then ''
        echo "Some parts of the current unit are not covered:" >&2
        (echo '${builtins.toJSON coverage}' | jq --sort-keys --raw-output 'to_entries[] | select(.value == false) | "- "+.key') >&2
      ''
      else ""
    } ${
      if strict && (haveExtra || isMissingCoverage)
      then "exit 1"
      else "touch $out"
    }
  ''
