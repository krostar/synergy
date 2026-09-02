{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.tflint = with lib.types; {
      enable = lib.mkEnableOption "tflint";

      paths = lib.mkOption {
        type = listOf str;
        default = ["."];
        example = ["infra" "modules/network"];
        description = "Directories to lint, relative to the project root.";
      };

      settings.config = lib.mkOption {
        type = nullOr str;
        default = null;
        example = ".tflint.hcl";
        description = "Path to a tflint configuration file.";
      };
    };
  });
}
