{
  lib,
  synergy-lib,
  ...
} @ args: let
  commands = lib.attrsets.filterAttrs (_: cmd: cmd.enable) (synergy-lib.autoimport {
    inherit args;
    source = ./lint;
    flatten = true;
    merge = true;
  });
  commandsNames = builtins.filter (k: !lib.strings.hasPrefix "_run" k) (builtins.attrNames commands);
in
  {
    lint = {
      enable = true;
      groups = ["linters"];
      dependencies = commandsNames;
    };
  }
  // commands
