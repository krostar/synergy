{
  lib,
  unit,
  ...
}: [
  {
    enabled = true;
    name = "Treefmt format";
    scope = "Current File";
    fileExtension = "*";
    workingDir = "$ProjectFileDir$";
    program = "${lib.getExe unit.packages.treefmt}";
    arguments = "$FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = true;
    name = "Lint against editorconfig";
    scope = "Current File";
    fileExtension = "*";
    workingDir = "$ProjectFileDir$";
    program = "${lib.getExe unit.packages.lint-editorconfig}";
    arguments = "$FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = true;
    name = "Lint github actions";
    scope = "Current File";
    fileExtension = "ghe";
    workingDir = "$ProjectFileDir$";
    program = "${lib.getExe unit.packages.lint-ghaction}";
    arguments = "$FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = true;
    name = "Lint sh file";
    scope = "Current File";
    fileExtension = "sh";
    workingDir = "$ProjectFileDir$";
    program = "${lib.getExe unit.packages.lint-sh}";
    arguments = "$FileRelativePath$";
    output = "$FileRelativePath$";
  }
  {
    enabled = true;
    name = "Lint yaml file";
    scope = "Current File";
    fileExtension = "yml";
    workingDir = "$ProjectFileDir$";
    program = "${lib.getExe unit.packages.lint-yaml}";
    arguments = "$FileRelativePath$";
    output = "$FileRelativePath$";
  }
]
