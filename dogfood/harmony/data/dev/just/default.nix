{synergy-lib, ...} @ args: {
  settings = {
    unstable = "true";
  };

  recipes = synergy-lib.autoimport {
    inherit args;
    source = ./recipes;
    squash = true;
  };
}
