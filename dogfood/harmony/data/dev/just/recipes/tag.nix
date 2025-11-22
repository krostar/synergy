{
  data,
  lib,
  pkgs,
  unit,
  ...
}: let
  inherit (unit.lib) nixago;
in {
  tag = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.dev.git-cliff;

    inherit
      (nixago.make {
        inherit pkgs;
        file = nixago.files.git-cliff;
        data = cfg.settings;
      })
      configFile
      ;
  in {
    inherit (cfg) enable;
    parameters = [''+BUMP="auto"''];
    recipe = ''
      ${lib.meta.getExe (pkgs.writeShellApplication {
        name = "tag-with-changelog";

        runtimeInputs = with pkgs; [git git-cliff];
        checkPhase = "";

        text = ''
          bump="$1"
          version="$(git-cliff --config "${configFile}" --bump="$bump" --bumped-version --output=-)"

          git-cliff --config "${configFile}" --bump="$bump"

          git add "${cfg.settings.changelog.output}"
          git commit --amend --no-edit
          git tag "$version"
        '';
      })} {{ BUMP }}
    '';
  };
}
