{
  lib,
  pkgs,
  ...
}: {
  build-nix = {
    enable = true;
    groups = ["builders"];
    parameters = ["FLAKE_INSTALLABLE" "*NIX_ARGS"];
    recipe = ''nix build --log-format internal-json -v {{ NIX_ARGS }} {{ FLAKE_INSTALLABLE }} |& ${lib.meta.getExe pkgs.nix-output-monitor} --json'';
  };
}
