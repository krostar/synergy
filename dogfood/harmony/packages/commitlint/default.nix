{
  pkgs,
  lib,
  ...
}: let
  nodeModules = pkgs.importNpmLock.buildNodeModules {
    package = lib.importJSON ./package.json;
    packageLock = lib.importJSON ./package-lock.json;
    inherit (pkgs) nodejs;
  };
in
  pkgs.stdenv.mkDerivation {
    name = "commitlint";
    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
      makeWrapper ${pkgs.commitlint}/bin/commitlint $out/bin/commitlint \
        --set NODE_PATH "${nodeModules}/node_modules"
    '';

    meta.mainProgram = "commitlint";
  }
