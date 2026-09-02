{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.trivy = with lib.types; {
      enable = lib.mkEnableOption "trivy config (IaC misconfiguration scanning)";

      paths = lib.mkOption {
        type = listOf str;
        default = ["."];
        example = ["infra" "modules/network"];
        description = "Directories to scan, relative to the project root.";
      };

      settings = {
        severity = lib.mkOption {
          type = listOf (enum ["UNKNOWN" "LOW" "MEDIUM" "HIGH" "CRITICAL"]);
          default = ["HIGH" "CRITICAL"];
          description = "Severities that trivy reports on.";
        };

        exitCode = lib.mkOption {
          type = int;
          default = 1;
          description = "Exit code returned when misconfigurations are found.";
        };
      };
    };
  });
}
