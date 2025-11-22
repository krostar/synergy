{
  data,
  lib,
  pkgs,
  unit,
  ...
} @ args:
unit.lib.just.mkRecipe "linters" "lint-nix" {
  alejandra-check = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.alejandra;
  in {
    inherit (cfg) enable;
    groups = ["nix"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.alejandra} --check ${
        builtins.concatStringsSep " " (builtins.map (i: "--exclude ${lib.strings.escapeShellArg i}") (cfg.settings.exclude or []))
      } {{ if FILES == "" { "." } else { FILES } }}
    '';
  };

  statix = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.statix;
  in {
    inherit (cfg) enable;
    groups = ["nix"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.statix} check ${
        if builtins.length (cfg.settings.ignore or []) > 0
        then "--ignore ${builtins.concatStringsSep " " (builtins.map lib.strings.escapeShellArg cfg.settings.ignore)}"
        else ""
      } {{ FILES }}
    '';
  };

  nixfmt-rfc-style-check = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.nixfmt-rfc-style;
  in {
    inherit (cfg) enable;
    groups = ["nix"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe' pkgs.nixfmt-rfc-style "nixfmt"} --check --verify --strict -- {{ if FILES == "" { "${builtins.concatStringsSep " " (builtins.map (v: lib.strings.escapeShellArg v) cfg.settings.include)}" } else { FILES } }}
    '';
  };

  deadnix = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.deadnix;
  in {
    inherit (cfg) enable;
    groups = ["nix"];
    parameters = ["*FILES"];
    recipe = ''
      ${lib.meta.getExe pkgs.deadnix} --fail --hidden ${
        if builtins.length (cfg.settings.exclude or []) > 0
        then "--exclude ${builtins.concatStringsSep " " (builtins.map lib.strings.escapeShellArg cfg.settings.exclude)}"
        else ""
      } -- {{ FILES }}
    '';
  };

  flake-checker = let
    cfg = data.${pkgs.stdenv.hostPlatform.system}.ci.linters.flake-checker;
  in {
    enable = true;
    groups = ["nix"];
    recipe = lib.strings.concatStringsSep " " (
      [(lib.meta.getExe' (cfg.package args) "flake-checker")]
      ++ (lib.lists.optional (cfg.flakeLockPath != null) cfg.flakeLockPath)
      ++ (lib.lists.optional cfg.noTelemetry "--no-telemetry")
      ++ (lib.lists.optional cfg.checkOutdated "--check-outdated")
      ++ (lib.lists.optional cfg.checkOwner "--check-owner")
      ++ (lib.lists.optional cfg.checkSupported "--check-supported")
      ++ (lib.lists.optional cfg.ignoreMissingFlakeLock "--ignore-missing-flake-lock")
      ++ (lib.lists.optional cfg.failMode "--fail-mode")
      ++ (lib.lists.optional (builtins.length cfg.nixpkgsKeys > 0) "--nixpkgs-keys ${lib.strings.concatStringsSep "," cfg.nixpkgsKeys}")
      ++ (lib.lists.optional cfg.markdownSummary "--markdown-summary")
      ++ (lib.lists.optional (cfg.condition != null) "--condition '${cfg.condition}'")
    );
  };
}
