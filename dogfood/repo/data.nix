{units, ...}: let
  alejandraSlowNixFiles = [
    # alejandra for some reasons is extremely slow when dealing with those files
    "dogfood/harmony/collectors/data/ci/linters/golangci-lint.nix"
  ];
in {
  ci.linters = {
    lint-sh.additionalFiles = builtins.map (f: "${f}/bin/*") (with units.harmony.packages; [
      lint-editorconfig
      lint-ghaction
      lint-go
      lint-nix
      lint-renovate
      lint-yaml
      renovate-diff
      treefmt
    ]);
    lint-nix.alejandra.exclude = builtins.map (f: "./${f}") alejandraSlowNixFiles;
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
