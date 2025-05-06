{
  data,
  pkgs,
  ...
}: let
  inherit (data.${pkgs.system}.ci.linters) alejandra;
in {
  enable = (alejandra.enable && (builtins.length alejandra.settings.exclude) > 0) || !alejandra.enable;
  settings.include = alejandra.settings.exclude;
}
