{synergy-lib, ...} @ args: {
  enable = true;

  recipes = synergy-lib.autoimport {
    inherit args;
    source = ./recipes;
    flatten = true;
    merge = true;
  };
}
