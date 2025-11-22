{
  data,
  unit,
  ...
}: pkgs: shellHooks: let
  nixagoFilesConfigs =
    builtins.filter
    (i: i != {})
    (builtins.attrValues data.${pkgs.stdenv.hostPlatform.system}.dev.nixago);
in
  if builtins.length nixagoFilesConfigs > 0
  then
    (
      if builtins.stringLength shellHooks > 0
      then shellHooks + "\n\n"
      else ""
    )
    + "# nixago hooks {\n"
    + "\n"
    + (unit.lib.nixago.makeAll {
      inherit pkgs;
      configs = nixagoFilesConfigs;
      log = false;
    }).shellHook
    + "\n"
    + "# nixago hooks }\n"
  else shellHooks
