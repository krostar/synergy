{
  enable = true;
  settings = {
    include = {
      find = ["*.sh" "*.bash" "*.zsh"];
      files = ["./.envrc"];
    };
  };
}
