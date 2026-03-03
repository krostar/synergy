{ systems, unit, ... }:
{ lib, ... }:
{
  options.data = lib.attrsets.genAttrs systems (_: {
    ci.linters.yamllint = {
      enable = lib.mkEnableOption "yamllint";
      settings = lib.mkOption {
        type = lib.types.submodule {
          options =
            let
              toggleOrSubmodule =
                extraOptions:
                lib.types.nullOr (
                  lib.types.either
                    (lib.types.enum [
                      "enable"
                      "disable"
                    ])
                    (
                      lib.types.submodule {
                        options = {
                          level = lib.mkOption {
                            type = lib.types.nullOr (
                              lib.types.enum [
                                "error"
                                "warning"
                              ]
                            );
                            default = null;
                          };
                          ignore = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                            default = null;
                          };
                          ignore-from-file = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                            default = null;
                          };
                        }
                        // extraOptions;
                      }
                    )
                );
              toggleOnly = toggleOrSubmodule { };
            in
            {
              extends = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              yaml-files = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = null;
              };

              locale = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              ignore = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                default = null;
              };

              ignore-from-file = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                default = null;
              };

              rules = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.submodule {
                    options = {
                      anchors = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid-undeclared-aliases = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-duplicated-anchors = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-unused-anchors = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      braces = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.bool (lib.types.enum [ "non-empty" ]));
                            default = null;
                          };
                          min-spaces-inside = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-inside = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          min-spaces-inside-empty = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-inside-empty = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      brackets = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.bool (lib.types.enum [ "non-empty" ]));
                            default = null;
                          };
                          min-spaces-inside = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-inside = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          min-spaces-inside-empty = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-inside-empty = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      colons = lib.mkOption {
                        type = toggleOrSubmodule {
                          max-spaces-before = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-after = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      commas = lib.mkOption {
                        type = toggleOrSubmodule {
                          max-spaces-before = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          min-spaces-after = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-spaces-after = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      comments = lib.mkOption {
                        type = toggleOrSubmodule {
                          require-starting-space = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          ignore-shebangs = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          min-spaces-from-content = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      comments-indentation = lib.mkOption {
                        type = toggleOnly;
                        default = null;
                      };

                      document-end = lib.mkOption {
                        type = toggleOrSubmodule {
                          present = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      document-start = lib.mkOption {
                        type = toggleOrSubmodule {
                          present = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      empty-lines = lib.mkOption {
                        type = toggleOrSubmodule {
                          max = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-start = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          max-end = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      empty-values = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid-in-block-mappings = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-in-flow-mappings = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-in-block-sequences = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      float-values = lib.mkOption {
                        type = toggleOrSubmodule {
                          require-numeral-before-decimal = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-scientific-notation = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-nan = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-inf = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      hyphens = lib.mkOption {
                        type = toggleOrSubmodule {
                          max-spaces-after = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      indentation = lib.mkOption {
                        type = toggleOrSubmodule {
                          spaces = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.int (lib.types.enum [ "consistent" ]));
                            default = null;
                          };
                          indent-sequences = lib.mkOption {
                            type = lib.types.nullOr (
                              lib.types.either lib.types.bool (
                                lib.types.enum [
                                  "consistent"
                                  "whatever"
                                ]
                              )
                            );
                            default = null;
                          };
                          check-multi-line-strings = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      key-duplicates = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid-duplicated-merge-keys = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      key-ordering = lib.mkOption {
                        type = toggleOrSubmodule {
                          ignored-keys = lib.mkOption {
                            type = lib.types.nullOr (lib.types.listOf lib.types.str);
                            default = null;
                          };
                        };
                        default = null;
                      };

                      line-length = lib.mkOption {
                        type = toggleOrSubmodule {
                          max = lib.mkOption {
                            type = lib.types.nullOr lib.types.int;
                            default = null;
                          };
                          allow-non-breakable-words = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          allow-non-breakable-inline-mappings = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      new-line-at-end-of-file = lib.mkOption {
                        type = toggleOnly;
                        default = null;
                      };

                      new-lines = lib.mkOption {
                        type = toggleOrSubmodule {
                          type = lib.mkOption {
                            type = lib.types.nullOr (
                              lib.types.enum [
                                "unix"
                                "dos"
                                "platform"
                              ]
                            );
                            default = null;
                          };
                        };
                        default = null;
                      };

                      octal-values = lib.mkOption {
                        type = toggleOrSubmodule {
                          forbid-implicit-octal = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          forbid-explicit-octal = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };

                      quoted-strings = lib.mkOption {
                        type = toggleOrSubmodule {
                          quote-type = lib.mkOption {
                            type = lib.types.nullOr (
                              lib.types.enum [
                                "single"
                                "double"
                                "any"
                              ]
                            );
                            default = null;
                          };
                          required = lib.mkOption {
                            type = lib.types.nullOr (lib.types.either lib.types.bool (lib.types.enum [ "only-when-needed" ]));
                            default = null;
                          };
                          allow-quoted-quotes = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          check-keys = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                          extra-required = lib.mkOption {
                            type = lib.types.nullOr (lib.types.listOf lib.types.str);
                            default = null;
                          };
                          extra-allowed = lib.mkOption {
                            type = lib.types.nullOr (lib.types.listOf lib.types.str);
                            default = null;
                          };
                        };
                        default = null;
                      };

                      trailing-spaces = lib.mkOption {
                        type = toggleOnly;
                        default = null;
                      };

                      truthy = lib.mkOption {
                        type = toggleOrSubmodule {
                          allowed-values = lib.mkOption {
                            type = lib.types.nullOr (
                              lib.types.listOf (
                                lib.types.enum [
                                  "TRUE"
                                  "True"
                                  "true"
                                  "FALSE"
                                  "False"
                                  "false"
                                  "YES"
                                  "Yes"
                                  "yes"
                                  "NO"
                                  "No"
                                  "no"
                                  "ON"
                                  "On"
                                  "on"
                                  "OFF"
                                  "Off"
                                  "off"
                                ]
                              )
                            );
                            default = null;
                          };
                          check-keys = lib.mkOption {
                            type = lib.types.nullOr lib.types.bool;
                            default = null;
                          };
                        };
                        default = null;
                      };
                    };
                  }
                );
                default = null;
              };
            };
        };
        apply = unit.lib.attrsets.removeNullOrEmptyAttrs;
      };
    };
  });
}
