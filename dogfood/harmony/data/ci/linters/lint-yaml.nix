{
  data,
  pkgs,
  ...
}: {
  inherit (data.${pkgs.system}.ci.linters) yamllint;
}
