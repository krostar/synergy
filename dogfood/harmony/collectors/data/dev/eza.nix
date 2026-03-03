{
  unit,
  systems,
  ...
}: {lib, ...}: {
  options.data = lib.attrsets.genAttrs systems (_: {
    dev.eza = lib.mkOption {
      type = lib.types.submodule {
        options = let
          styleSubmodule = lib.types.submodule {
            options = {
              foreground = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              background = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              is_bold = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_dimmed = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_italic = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_underline = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_blink = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_reverse = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_hidden = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              is_strikethrough = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
              prefix_with_reset = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = null;
              };
            };
          };
          nullOrStyle = lib.types.nullOr styleSubmodule;
          fileIconStyleSubmodule = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                filename = lib.mkOption {
                  type = nullOrStyle;
                  default = null;
                };
                icon = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        glyph = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                        };
                        style = lib.mkOption {
                          type = nullOrStyle;
                          default = null;
                        };
                      };
                    }
                  );
                  default = null;
                };
              };
            }
          );
        in {
          filekinds = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  normal = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  directory = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  symlink = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  pipe = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  block_device = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  char_device = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  socket = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  special = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  executable = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  mount_point = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for file kinds.";
          };

          perms = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  user_read = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  user_write = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  user_executable_file = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  user_execute_other = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_read = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_write = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_execute = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  other_read = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  other_write = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  other_execute = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  special_user_file = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  special_other = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  attribute = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for permission bits.";
          };

          size = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  major = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  minor = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  number_byte = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  number_kilo = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  number_mega = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  number_giga = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  number_huge = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  unit_byte = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  unit_kilo = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  unit_mega = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  unit_giga = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  unit_huge = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for file sizes.";
          };

          users = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  user_you = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  user_root = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  user_other = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_yours = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_other = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  group_root = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for user and group names.";
          };

          links = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  normal = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  multi_link_file = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for hard links.";
          };

          git = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  new = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  modified = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  deleted = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  renamed = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  ignored = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  conflicted = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for git file status.";
          };

          git_repo = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  branch_main = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  branch_other = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  git_clean = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  git_dirty = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for git repository metadata.";
          };

          security_context = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  none = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  selinux = lib.mkOption {
                    type = lib.types.nullOr (
                      lib.types.submodule {
                        options = {
                          colon = lib.mkOption {
                            type = nullOrStyle;
                            default = null;
                          };
                          user = lib.mkOption {
                            type = nullOrStyle;
                            default = null;
                          };
                          role = lib.mkOption {
                            type = nullOrStyle;
                            default = null;
                          };
                          typ = lib.mkOption {
                            type = nullOrStyle;
                            default = null;
                          };
                          range = lib.mkOption {
                            type = nullOrStyle;
                            default = null;
                          };
                        };
                      }
                    );
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for security context labels.";
          };

          file_type = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  image = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  video = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  music = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  crypto = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  document = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  compressed = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  temp = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  compiled = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  build = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                  source = lib.mkOption {
                    type = nullOrStyle;
                    default = null;
                  };
                };
              }
            );
            default = null;
            description = "Style for file types.";
          };

          punctuation = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for punctuation characters.";
          };
          date = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for date and time values.";
          };
          inode = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for inode numbers.";
          };
          blocks = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for block counts.";
          };
          header = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for column headers.";
          };
          octal = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for octal permission values.";
          };
          flags = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for BSD flags.";
          };
          control_char = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for non-printable control characters.";
          };
          broken_symlink = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for broken symbolic links.";
          };
          broken_path_overlay = lib.mkOption {
            type = nullOrStyle;
            default = null;
            description = "Style for the broken path overlay.";
          };

          filenames = lib.mkOption {
            type = lib.types.nullOr fileIconStyleSubmodule;
            default = null;
            description = "Style overrides keyed by file name.";
          };

          extensions = lib.mkOption {
            type = lib.types.nullOr fileIconStyleSubmodule;
            default = null;
            description = "Style overrides keyed by file extension.";
          };
        };
      };
      default = {};
      apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
    };
  });
}
