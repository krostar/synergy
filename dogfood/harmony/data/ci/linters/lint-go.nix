{
  data,
  pkgs,
  ...
}: {
  inherit (data.${pkgs.system}.ci.linters) golangci-lint;
}
