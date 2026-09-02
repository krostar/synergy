{systems, ...}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.testers.terraform = with lib.types; {
      enable = lib.mkEnableOption "tofu test";

      paths = lib.mkOption {
        type = listOf str;
        default = ["."];
        example = ["infra" "modules/network"];
        description = "Directories to run tofu test in, relative to the project root.";
      };

      extraFlags = lib.mkOption {
        type = listOf str;
        default = [];
        example = ["-verbose"];
        description = "Extra flags passed to tofu test.";
      };
    };
  });
}
