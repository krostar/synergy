## TODO
- dependencies

# TODO:
to better flag files / references can we wrap imports with
_file = "pkgs.runNixOSTest implementation";
imports = [
    (lib.setDefaultModuleLocation "the argument that was passed to pkgs.runNixOSTest" testModule)
];