{units, ...}: let
  alejandraSlowNixFiles = [
    # alejandra for some reasons is extremely slow when dealing with those files
    "dogfood/harmony/collectors/data/ci/linters/golangci-lint.nix"
  ];
in {
  ci.linters = let
    shellFilesToInclude = {
      files = builtins.map (f: "${f}/bin/*") (with units.harmony.packages; [
        renovate-diff
        treefmt
      ]);
    };
  in {
    bashate.settings.include = shellFilesToInclude;
    shellcheck.settings.include = shellFilesToInclude;
    shellharden.settings.include = shellFilesToInclude;
    alejandra.settings.exclude = builtins.map (f: "./${f}") alejandraSlowNixFiles;
    editorconfig-checker.settings.Exclude = ["COPYING" "COPYING.LESSER"];
  };

  dev.formatters.treefmt = {
    programs = {
      alejandra.excludes = alejandraSlowNixFiles;
      nixfmt = {
        enable = true;
        includes = alejandraSlowNixFiles;
        strict = true;
      };
    };
  };
}
