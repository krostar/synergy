{
  enable = true;
  settings = {
    ignore = [
      "E003" # Indent not multiple of 4
      "E006" # Line too long
    ];
    include = {
      find = ["*.sh" "*.bash" "*.zsh"];
      files = ["./.envrc"];
    };
  };
}
