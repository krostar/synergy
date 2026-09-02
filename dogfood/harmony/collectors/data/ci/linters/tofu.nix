{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.tofu = with lib.types; {
      enable = lib.mkEnableOption "OpenTofu fmt and validate checks";

      paths = lib.mkOption {
        type = listOf str;
        default = ["."];
        example = ["infra" "modules/network"];
        description = "Directories to check, relative to the project root.";
      };

      fmt.enable =
        lib.mkEnableOption "tofu fmt -check"
        // {default = true;};

      validate.enable =
        lib.mkEnableOption "tofu validate"
        // {default = true;};
    };
  });
}
