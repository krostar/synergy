{
  enable = true;
  settings = {
    rules = {
      braces = {
        forbid = "non-empty";
        min-spaces-inside = 0;
        max-spaces-inside = 0;
        min-spaces-inside-empty = 0;
        max-spaces-inside-empty = 0;
      };
      brackets = {
        forbid = false;
        min-spaces-inside = 0;
        max-spaces-inside = 0;
        min-spaces-inside-empty = 0;
        max-spaces-inside-empty = 0;
      };
      colons = {
        max-spaces-before = 0;
        max-spaces-after = 1;
      };
      commas = {
        max-spaces-before = 0;
        min-spaces-after = 1;
        max-spaces-after = 1;
      };
      comments = {
        require-starting-space = true;
        ignore-shebangs = true;
        min-spaces-from-content = 1;
      };
      comments-indentation = {};
      document-end = {
        present = false;
      };
      document-start = {
        present = true;
      };
      empty-lines = {
        max = 2;
        max-start = 0;
        max-end = 0;
      };
      empty-values = {
        forbid-in-block-mappings = true;
        forbid-in-flow-mappings = true;
      };
      float-values = {
        forbid-inf = true;
        forbid-nan = true;
        forbid-scientific-notation = true;
        require-numeral-before-decimal = true;
      };
      hyphens = {
        max-spaces-after = 1;
      };
      indentation = {
        spaces = "consistent";
        indent-sequences = true;
        check-multi-line-strings = false;
      };
      key-duplicates = {};
      key-ordering = "disable";
      line-length = "disable";
      new-line-at-end-of-file = {};
      new-lines = {};
      octal-values = {
        forbid-implicit-octal = true;
        forbid-explicit-octal = false;
      };
      quoted-strings = {
        quote-type = "double";
        required = true;
        extra-required = [];
        extra-allowed = [];
        allow-quoted-quotes = true;
      };
      trailing-spaces = {};
      truthy = {
        allowed-values = ["true" "false"];
        check-keys = false;
      };
    };
  };
}
