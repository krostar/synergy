{
  lib,
  root,
}: let
  inherit (root.attrsets) removeEmptySets;
in
  # This function recursively traverses a source tree and implements the standard
  # Nix convention where default.nix files serve as the canonical entry point for
  # their containing directories. When such a file is found, the entire directory
  # structure is replaced with just the default.nix file.
  #
  # default.nix detection criteria:
  # - the attribute set must contain a "default.nix" key
  # - the value must be a boolean (not a directory)
  # - the boolean value must be true
  #
  # Examples:
  #     sources = {
  #       withDefault = {
  #         "default.nix" = true;
  #         "other.nix" = true;
  #         submodule = {
  #           "nested.nix" = true;
  #         };
  #       };
  #       withoutDefault = {
  #         "main.nix" = true;
  #         "config.nix" = true;
  #       };
  #       outer = {
  #         "default.nix" = false;
  #         inner = {
  #           "default.nix" = true;
  #           "implementation.nix" = true;
  #         };
  #       };
  #     };
  #
  #     stopAtDefaultNixFile sources
  #     => {
  #          withDefault = {
  #            "default.nix" = true;
  #          };
  #          withoutDefault = {
  #            "main.nix" = true;
  #            "config.nix" = true;
  #          };
  #          outer = {
  #            "default.nix" = false;
  #            inner = {
  #              "default.nix" = true;
  #            };
  #          };
  #        }
  sources: let
    hasDefaultNixRegularFile = attrs:
      builtins.isAttrs attrs
      && builtins.hasAttr "default.nix" attrs
      && builtins.isBool attrs."default.nix"
      && attrs."default.nix";

    walkThrough = attrs:
      if hasDefaultNixRegularFile attrs
      then {"default.nix" = attrs."default.nix";}
      else if builtins.isAttrs attrs
      then lib.attrsets.mapAttrs (_: walkThrough) attrs
      else attrs;
  in
    removeEmptySets (walkThrough sources)
