{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.govulncheck = with lib.types; {
      enable = lib.mkEnableOption "govulncheck";

      package = lib.mkOption {
        type = types.package;
        default = pkgs.govulncheck;
        description = "The govulncheck package to use.";
      };

      failIfVulnFound = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Fail if any vulnerabilities are found.";
      };
    };
  });
}
