args: {
  debug = {
    args = builtins.attrNames args;
    synergy = args._synergy;
  };
}
