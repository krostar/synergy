{
  lib,
  pkgs,
  ...
}:
pkgs.buildGoModule rec {
  pname = "gta";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "digitalocean";
    repo = "gta";
    tag = "v${version}";
    hash = "sha256-BJ13Mm6YeicQO7+jOhM7eg8pmy9pKfxVxH6035/zCPo=";
  };

  subPackages = ["cmd/gta"];
  vendorHash = null;

  patches = [./load-current-module-only.patch];

  nativeBuildInputs = [pkgs.makeWrapper];

  postInstall = ''
    wrapProgram $out/bin/gta --suffix PATH : ${lib.makeBinPath [pkgs.git]}
  '';

  meta = {
    description = "Detect which go packages are affected by a set of changes, including dependents";
    homepage = "https://github.com/digitalocean/gta";
    license = lib.licenses.asl20;
    mainProgram = "gta";
  };
}
