{
  lib,
  pkgs,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "lorri-notifier";
  src = ./.;
  nativeBuildInputs = [pkgs.makeWrapper];
  installPhase = ''
    mkdir -p $out/bin
    chmod +x script.sh
    mv script.sh $out/bin/lorri-notifier
    mv nix-ico.png $out/

    wrapProgram $out/bin/lorri-notifier                                                 \
      --set PATH ${lib.makeBinPath (with pkgs; [jq findutils lorri terminal-notifier])} \
      --set ICON "$out/nix-ico.png"
  '';
}
