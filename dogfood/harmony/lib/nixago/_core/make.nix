# Vendored and adapted from nixago (https://github.com/nix-community/nixago).
# MIT License; Copyright (c) 2022 Joshua Gilman. See ./LICENSE.
{
  pkgs,
  lib,
}: request: let
  r = import ./request.nix {inherit lib;} request;

  engine = r.engine or (import ./engines/nix.nix {inherit pkgs lib;} {});

  # nixago behavior kept: the engine sees post-apply data, but hook.extra
  # (string-or-function) receives the RAW pre-apply data.
  reifiedRequest =
    r
    // {
      data = r.apply r.data;
      hook = r.hook // {extra = (lib.trivial.toFunction r.hook.extra) r.data;};
    };

  # The defined interface between nixago and an engine is that it takes exactly
  # one parameter: the reified request. The result should be a derivation which
  # builds the desired configuration file.
  configFile = engine reifiedRequest;

  inherit
    (import ./hooks {inherit pkgs lib;} {
      inherit configFile;
      # upstream hardcoded "temp" here; name hook scripts after their output
      # file instead so store paths and trace output are identifiable
      name = lib.strings.sanitizeDerivationName (builtins.baseNameOf r.output);
      hookConfig = {
        inherit (reifiedRequest) output;
        inherit (reifiedRequest.hook) extra mode;
      };
    })
    shellHook
    shellScript
    ;

  # Provides a stand-alone `nix run`-runnable to install this nixago file
  install = pkgs.writeShellScriptBin "nixago_shell_hook" shellHook;
in {
  inherit configFile shellHook shellScript install;
}
