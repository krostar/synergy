{
  data,
  lib,
  pkgs,
  ...
}: let
  just = data.${pkgs.system}.dev.just.recipes;
  justExe = lib.getExe pkgs.just;
in [
  {
    enabled = just.fmt.enable;
    name = "Format";
    scope = "Current File";
    fileExtension = "*";
    workingDir = "$ProjectFileDir$";
    program = justExe;
    arguments = "fmt $FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = just.lint-editorconfig.enable;
    name = "Lint against editorconfig";
    scope = "Current File";
    fileExtension = "*";
    workingDir = "$ProjectFileDir$";
    program = justExe;
    arguments = "lint-editorconfig";
    output = "$FileRelativePath$";
  }
  {
    enabled = just.lint-github.enable;
    name = "Lint github actions";
    scope = "Current File";
    fileExtension = "ghe";
    workingDir = "$ProjectFileDir$";
    program = justExe;
    arguments = "lint-ghaction $FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = just.lint-sh.enable;
    name = "Lint sh file";
    scope = "Current File";
    fileExtension = "sh";
    workingDir = "$ProjectFileDir$";
    program = justExe;
    arguments = "lint-sh $FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = just.lint-yaml.enable;
    name = "Lint yaml file";
    scope = "Current File";
    fileExtension = "yml";
    workingDir = "$ProjectFileDir$";
    program = justExe;
    arguments = "lint-yaml $FileRelativePath$";
    output = "$FileRelativePath$";
  }
]
