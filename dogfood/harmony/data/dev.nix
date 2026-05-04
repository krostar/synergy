{
  units,
  data,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  nixago =
    lib.optionalAttrs data.${system}.dev.just.enable {
      justfile = units.harmony.lib.nixago.files.justfile data.${system}.dev.just pkgs;
    }
    // lib.optionalAttrs data.${system}.dev.editorconfig.enable {
      editorconfig = units.harmony.lib.nixago.files.editorconfig data.${system}.dev.editorconfig pkgs;
    }
    // lib.optionalAttrs data.${system}.dev.intellij-idea.file-watchers.enable {
      intellij-idea-file-watchers = units.harmony.lib.nixago.files.intellij-idea.file-watchers data.${system}.dev.intellij-idea.file-watchers.tasks pkgs;
    };
}
