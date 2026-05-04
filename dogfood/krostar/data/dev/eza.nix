{
  defaultFlags = [
    "--color-scale-mode=fixed"
    "--git"
    "--group-directories-first"
    "--group"
    "--header"
    "--icons"
    "--show-symlinks"
  ];

  theme = {
    users = {
      user_you = {
        foreground = "White";
        is_bold = false;
      };
      group_yours = {
        foreground = "White";
        is_bold = false;
      };

      user_root = {
        foreground = "#b22222";
        is_bold = true;
      };
      group_root = {
        foreground = "#b22222";
        is_bold = true;
      };

      user_other = {
        foreground = "#fff68f";
        is_bold = false;
      };
      group_other = {
        foreground = "#fff68f";
        is_bold = false;
      };
    };

    filenames = {
      "flake.nix" = {
        filename = {prefix_with_reset = true;};
        icon.style = {prefix_with_reset = true;};
      };
    };

    extensions = {
      md = {
        filename = {prefix_with_reset = true;};
        icon.style = {prefix_with_reset = true;};
      };
    };
  };
}
