{
  lib,
  synergy-lib,
  ...
} @ args: let
  commands = lib.attrsets.filterAttrs (_: cmd: cmd.enable) (synergy-lib.autoimport {
    inherit args;
    source = ./test;
    flatten = true;
    merge = true;
  });
  commandsNames = builtins.filter (k: !lib.strings.hasPrefix "_run" k) (builtins.attrNames commands);
in
  {
    test = {
      enable = true;
      groups = ["testers"];
      dependencies = commandsNames;
    };
  }
  // commands
