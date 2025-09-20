{
  config,
  lib,
  synergy-lib,
  ...
}: let
  # source: https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/misc/nixpkgs.nix#L47-L52
  overlayType = lib.mkOptionType {
    name = "nixpkgs-overlay";
    description = "nixpkgs overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };
in {
  options.overlays = lib.mkOption {
    type = with lib.types; attrsOf (attrsOf overlayType);
    default = config.synergy.result.systemless.overlays or {};
    readOnly = true;
  };

  config = let
    cfg = config.overlays;
    export = config.synergy.export.overlays or (synergy-lib.attrsets.liftChildren "-");
    output = export cfg;
  in {
    synergy.collected.overlays.systemless = true;
    flake = lib.mkIf (output != {}) {overlays = output;};
  };
}
