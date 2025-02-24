{ data, unit, ... }:
{ lib, ... }:
{
  options.data = lib.attrsets.genAttrs (builtins.attrNames data) (_: {
    ci.linters.golangci-lint = lib.mkOption {
      type =
        with lib.types;
        types.submodule {
          options = {
            run = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    concurrency = lib.mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = "Number of concurrent runners";
                    };

                    timeout = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Timeout for the analysis (e.g., \"30s\", \"5m\")";
                    };

                    issues-exit-code = lib.mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = "Exit code when at least one issue was found";
                    };

                    tests = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Enable inclusion of test files";
                    };

                    build-tags = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "List of build tags to pass to all linters";
                    };

                    modules-download-mode = lib.mkOption {
                      type = types.nullOr (
                        types.enum [
                          "mod"
                          "readonly"
                          "vendor"
                        ]
                      );
                      default = null;
                      description = "Option to pass to \"go list -mod={option}\"";
                    };

                    allow-parallel-runners = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Allow multiple parallel golangci-lint instances running";
                    };

                    allow-serial-runners = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Allow multiple golangci-lint instances running, but serialize them around a lock";
                    };

                    go = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Targeted Go version";
                    };
                  };
                }
              );
              default = null;
            };

            output = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    formats = lib.mkOption {
                      type = types.nullOr (
                        types.listOf (
                          types.submodule {
                            options = {
                              path = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                                description = "Output path (stdout, stderr, or file path)";
                              };
                              format = lib.mkOption {
                                type = types.enum [
                                  "colored-line-number"
                                  "line-number"
                                  "json"
                                  "colored-tab"
                                  "tab"
                                  "html"
                                  "checkstyle"
                                  "code-climate"
                                  "junit-xml"
                                  "junit-xml-extended"
                                  "github-actions"
                                  "teamcity"
                                  "sarif"
                                ];
                                default = "colored-line-number";
                                description = "Output format";
                              };
                            };
                          }
                        )
                      );
                      default = null;
                      description = "Output formats";
                    };

                    print-issued-lines = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Print lines of code with issue";
                    };

                    print-linter-name = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Print linter name in the end of issue text";
                    };

                    uniq-by-line = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Make issues output unique by line";
                    };

                    path-prefix = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Add a prefix to the output file references";
                    };

                    show-stats = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Show statistics per linter";
                    };

                    sort-order = lib.mkOption {
                      type = types.nullOr (
                        types.listOf (
                          types.enum [
                            "linter"
                            "severity"
                            "file"
                          ]
                        )
                      );
                      default = null;
                      description = "Sort results by criteria (linter, severity, file)";
                    };

                    sort-results = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Sort results by filepath, line, and column";
                    };
                  };
                }
              );
              default = null;
            };

            linters-settings = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    dupword = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            keywords = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = ''
                                Keywords for detecting duplicate words. If this list is not
                                empty, only the words defined in this list will be detected.
                              '';
                            };

                            ignore = lib.mkOption {
                              default = null;
                              description = "Keywords used to ignore detection";
                              type = types.nullOr (types.listOf types.str);
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    asasalint = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            exclude = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "To specify a set of function names to exclude";
                            };

                            use-builtin-exclusions = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "To enable/disable the asasalint builtin exclusions of function names";
                            };

                            ignore-test = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore *_test.go files";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    bidichk = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            left-to-right-embedding = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: LEFT-TO-RIGHT-EMBEDDING";
                            };

                            right-to-left-embedding = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: RIGHT-TO-LEFT-EMBEDDING";
                            };

                            pop-directional-formatting = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: POP-DIRECTIONAL-FORMATTING";
                            };

                            left-to-right-override = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: LEFT-TO-RIGHT-OVERRIDE";
                            };

                            right-to-left-override = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: RIGHT-TO-LEFT-OVERRIDE";
                            };

                            left-to-right-isolate = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: LEFT-TO-RIGHT-ISOLATE";
                            };

                            right-to-left-isolate = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: RIGHT-TO-LEFT-ISOLATE";
                            };

                            first-strong-isolate = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: FIRST-STRONG-ISOLATE";
                            };

                            pop-directional-isolate = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disallow: POP-DIRECTIONAL-ISOLATE";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    cyclop = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            skip-tests = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Should the linter execute on test files as well";
                            };

                            max-complexity = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Max complexity the function can have";
                            };

                            package-average = lib.mkOption {
                              type = types.nullOr types.float;
                              default = null;
                              description = "Max average complexity in package";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    decorder = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            dec-order = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "type"
                                    "const"
                                    "var"
                                    "func"
                                  ]
                                )
                              );
                              default = null;
                              description = "Order of declarations";
                            };

                            ignore-underscore-vars = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''Underscore vars (vars with "_" as the name) will be ignored at all checks'';
                            };

                            disable-dec-order-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Order of declarations is not checked";
                            };

                            disable-init-func-first-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow init func to be anywhere in file";
                            };

                            disable-dec-num-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Multiple global type, const and var declarations are allowed";
                            };

                            disable-type-dec-num-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Type declarations will be ignored for dec num check";
                            };

                            disable-const-dec-num-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Const declarations will be ignored for dec num check";
                            };

                            disable-var-dec-num-check = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Var declarations will be ignored for dec num check";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    depguard = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            rules = lib.mkOption {
                              type = types.attrsOf (
                                types.nullOr (
                                  types.submodule {
                                    options = {
                                      list-mode = lib.mkOption {
                                        type = types.nullOr (
                                          types.enum [
                                            "original"
                                            "strict"
                                            "lax"
                                          ]
                                        );
                                        default = null;
                                        description = "Used to determine the package matching priority";
                                      };

                                      files = lib.mkOption {
                                        type = types.nullOr (types.listOf types.str);
                                        default = null;
                                        description = "List of file globs that will match this list of settings to compare against";
                                      };

                                      allow = lib.mkOption {
                                        type = types.nullOr (types.listOf types.str);
                                        default = null;
                                        description = "List of allowed packages";
                                      };

                                      deny = lib.mkOption {
                                        type = types.nullOr (
                                          types.listOf (
                                            types.submodule {
                                              options = {
                                                desc = lib.mkOption {
                                                  type = types.nullOr types.str;
                                                  default = null;
                                                  description = "Description";
                                                };

                                                pkg = lib.mkOption {
                                                  type = types.nullOr types.str;
                                                  default = null;
                                                  description = "Package";
                                                };
                                              };
                                            }
                                          )
                                        );
                                        default = null;
                                        description = "Packages that are not allowed where the value is a suggestion";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "Rules to apply";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    dogsled = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            max-blank-identifiers = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Check assignments with too many blank identifiers";
                            };
                          };
                        }
                      );
                      default = null;
                      description = "Settings for the dogsled linter";
                    };

                    dupl = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            threshold = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Tokens count to trigger issue";
                            };
                          };
                        }
                      );
                      default = null;
                      description = "Settings for the dupl linter";
                    };

                    errcheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            check-type-assertions = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report about not checking errors in type assertions, i.e.: `a := b.(MyStruct)`";
                            };

                            check-blank = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report about assignment of errors to blank identifier";
                            };

                            exclude-functions = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of functions to exclude from checking, where each entry is a single function to exclude";
                            };

                            disable-default-exclusions = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "To disable the errcheck built-in exclude list";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    errchkjson = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            check-error-free-encoding = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check error-free of `encoding/json`, `encoding/xml` and `encoding/gob` methods";
                            };

                            report-no-exported = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Issue on struct that doesn't have exported fields";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    errorlint = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            errorf = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check whether fmt.Errorf uses the %w verb for formatting errors";
                            };

                            errorf-multi = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Permit more than 1 %w verb, valid per Go 1.20";
                            };

                            asserts = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check for plain type assertions and type switches";
                            };

                            comparison = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check for plain error comparisons";
                            };

                            allowed-errors = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      err = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                      };
                                      fun = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                            };
                            allowed-errors-wildcard = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      err = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                      };
                                      fun = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    exhaustive = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            check = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Program elements to check for exhaustiveness";
                            };

                            check-generated = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check switch statements in generated files";
                            };

                            explicit-exhaustive-switch = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''Only run exhaustive check on switches with "//exhaustive:enforce" comment'';
                            };

                            explicit-exhaustive-map = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''Only run exhaustive check on map literals with "//exhaustive:enforce" comment'';
                            };

                            default-case-required = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Switch statement requires default case even if exhaustive";
                            };

                            default-signifies-exhaustive = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Presence of `default` case in switch statements satisfies exhaustiveness, even if all enum members are not listed";
                            };

                            ignore-enum-members = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Enum members matching `regex` do not have to be listed in switch statements to satisfy exhaustiveness";
                            };

                            ignore-enum-types = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Enum types matching the supplied regex do not have to be listed in switch statements to satisfy exhaustiveness";
                            };

                            package-scope-only = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider enums only in package scopes, not in inner scopes";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    exhaustruct = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            include = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of regular expressions to match struct packages and names";
                            };

                            exclude = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of regular expressions to exclude struct packages and names from check";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    forbidigo = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            exclude-godoc-examples = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Exclude code in godoc examples";
                            };

                            analyze-types = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''
                                Instead of matching the literal source code, use type
                                information to replace expressions with strings that contain
                                the package name and (for methods and fields) the type name.
                              '';
                            };

                            forbid = lib.mkOption {
                              type = types.listOf types.str;
                              default = null;
                              description = "List of identifiers to forbid (written using `regexp`)";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    funlen = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            lines = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Limit lines number per function";
                            };

                            statements = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Limit statements number per function";
                            };

                            ignore-comments = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore comments when counting lines";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gci = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            sections = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Section configuration to compare against";
                            };

                            skip-generated = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Skip generated files";
                            };

                            custom-order = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable custom order of sections";
                            };

                            no-lex-order = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Drops lexical ordering for custom sections";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    ginkgolinter = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            suppress-len-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress the wrong length assertion warning";
                            };

                            suppress-nil-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress the wrong nil assertion warning";
                            };

                            suppress-err-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress the wrong error assertion warning";
                            };

                            suppress-compare-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress the wrong comparison assertion warning";
                            };

                            suppress-async-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress the function all in async assertion warning";
                            };

                            suppress-type-compare-assertion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suppress warning for comparing values from different types, like int32 and uint32";
                            };

                            forbid-focus-container = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Trigger warning for ginkgo focus containers like FDescribe, FContext, FWhen or FIt";
                            };

                            allow-havelen-zero = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Don't trigger warnings for HaveLen(0)";
                            };

                            force-expect-to = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Force using `Expect` with `To`, `ToNot` or `NotTo`";
                            };

                            validate-async-intervals = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Best effort validation of async intervals (timeout and polling)";
                            };

                            forbid-spec-pollution = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Trigger a warning for variable assignments in ginkgo containers like `Describe`, `Context` and `When`, instead of in `BeforeEach()`";
                            };

                            force-succeed = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Force using the Succeed matcher for error functions, and the HaveOccurred matcher for non-function error values";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gochecksumtype = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            default-signifies-exhaustive = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Presence of `default` case in switch statements satisfies exhaustiveness, if all members are not listed";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gocognit = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            min-complexity = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimal code complexity to report (we recommend 10-20)";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    goconst = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            match-constant = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Look for existing constants matching the values";
                            };

                            min-len = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimum length of string constant";
                            };

                            min-occurrences = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimum occurrences count to trigger";
                            };

                            ignore-tests = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore test files";
                            };

                            ignore-calls = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore when constant is not used as function argument";
                            };

                            ignore-strings = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Exclude strings matching the given regular expression";
                            };

                            numbers = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Search also for duplicated numbers";
                            };

                            min = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimum value, only works with `numbers`";
                            };

                            max = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Maximum value, only works with `numbers`";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gocritic = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            enabled-checks = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Which checks should be enabled. By default, a list of stable checks is used. To see it, run `GL_DEBUG=gocritic golangci-lint run`";
                            };

                            disabled-checks = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Which checks should be disabled";
                            };

                            enabled-tags = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Enable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks";
                            };

                            disabled-tags = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Disable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks";
                            };

                            settings = lib.mkOption {
                              type = types.nullOr (types.attrsOf types.unspecified);
                              default = null;
                              description = "Settings passed to gocritic. Properties must be valid and enabled check names";
                            };

                            disable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disable all checks marked for stable use in config";
                            };

                            enable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable all checks marked for stable use in config";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gocyclo = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            min-complexity = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimum code complexity to report (we recommend 10-20)";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    godot = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            scope = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "declarations"
                                  "toplevel"
                                  "all"
                                ]
                              );
                              default = null;
                              description = "Comments to be checked";
                            };

                            exclude = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of regexps for excluding particular comment lines from check";
                            };

                            period = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check that each sentence ends with a period";
                            };

                            capital = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check that each sentence starts with a capital letter";
                            };

                            check-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "DEPRECATED: Check all top-level comments, not only declarations";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    godox = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            keywords = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = ''
                                Report any comments starting with one of these keywords. This
                                is useful for TODO or FIXME comments that might be left in the
                                code accidentally and should be resolved before merging.
                              '';
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gofmt = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            simplify = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Simplify code";
                            };
                            rewrite-rules = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      pattern = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                        description = "Go syntax-compliant pattern to match";
                                      };
                                      replacement = lib.mkOption {
                                        type = types.nullOr types.str;
                                        default = null;
                                        description = "Replacement pattern to transform into";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "Apply the rewrite rules to the source before reformatting";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    interfacebloat = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            max = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "The maximum number of methods allowed for an interface";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gofumpt = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            extra-rules = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Choose whether or not to use the extra rules that are disabled by default";
                            };

                            module-path = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Module path which contains the source code being formatted";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    goheader = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            values = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    const = lib.mkOption {
                                      type = types.nullOr (types.attrsOf types.str);
                                      default = null;
                                      description = "Constants to use in the template";
                                    };

                                    regexp = lib.mkOption {
                                      type = types.nullOr (types.attrsOf types.str);
                                      default = null;
                                      description = "Regular expressions to use in your template";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Values to use in the template";
                            };

                            template = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Template to put on top of every file";
                            };

                            template-path = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Path to the file containing the template source";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    goimports = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            local-prefixes = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Put imports beginning with prefix after 3rd-party packages. It is a comma-separated list of prefixes.";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gomoddirectives = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            replace-local = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow local `replace` directives";
                            };

                            replace-allow-list = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of allowed `replace` directives";
                            };

                            retract-allow-no-explanation = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow to not explain why the version has been retracted in the `retract` directives";
                            };

                            exclude-forbidden = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Forbid the use of the `exclude` directives";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gomodguard = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            allowed = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    modules = lib.mkOption {
                                      type = types.nullOr (types.listOf types.str);
                                      default = null;
                                      description = "List of allowed modules";
                                    };

                                    domains = lib.mkOption {
                                      type = types.nullOr (types.listOf types.str);
                                      default = null;
                                      description = "List of allowed module domains";
                                    };
                                  };
                                }
                              );
                              default = null;
                            };

                            blocked = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    modules = lib.mkOption {
                                      type = types.nullOr (
                                        types.listOf (
                                          types.attrOf (
                                            types.submodule {
                                              options = {
                                                recommendations = lib.mkOption {
                                                  type = types.nullOr (types.listOf types.str);
                                                  default = null;
                                                  description = "Recommended modules that should be used instead";
                                                };

                                                reason = lib.mkOption {
                                                  type = types.nullOr types.str;
                                                  default = null;
                                                  description = "Reason why the recommended module should be used";
                                                };
                                              };
                                            }
                                          )
                                        )
                                      );
                                      default = null;
                                      description = "List of blocked modules";
                                    };

                                    versions = lib.mkOption {
                                      type = types.nullOr (
                                        types.listOf (
                                          types.submodule {
                                            options = {
                                              version = lib.mkOption {
                                                type = types.nullOr types.str;
                                                default = null;
                                                description = "Version constraint";
                                              };

                                              reason = lib.mkOption {
                                                type = types.nullOr types.str;
                                                default = null;
                                                description = "Reason why the version constraint exists";
                                              };
                                            };
                                          }
                                        )
                                      );
                                      default = null;
                                      description = "List of blocked module version constraints";
                                    };

                                    local_replace_directives = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Raise lint issues if loading local path with replace directive";
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
                    };

                    gosimple = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            checks = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Checks to include in analysis, `all` is also accepted";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gosec = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            includes = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "To select a subset of rules to run";
                            };

                            excludes = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "To specify a set of rules to explicitly exclude";
                            };

                            exclude-generated = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Exclude generated files";
                            };

                            severity = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "low"
                                  "medium"
                                  "high"
                                ]
                              );
                              default = null;
                              description = "Filter out the issues with a lower severity than the given value";
                            };

                            confidence = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "low"
                                  "medium"
                                  "high"
                                ]
                              );
                              default = null;
                              description = "Filter out the issues with a lower confidence than the given value";
                            };

                            config = lib.mkOption {
                              type = types.nullOr (types.attrsOf types.unspecified);
                              default = null;
                              description = "To specify the configuration of rules";
                            };

                            concurrency = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Set the concurrency level for the scanner. By default, this is set to the number of CPUs.";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    gosmopolitan = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            allow-time-local = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow and ignore `time.Local` usages";
                            };

                            escape-hatches = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = ''List of fully qualified names in the `full/pkg/path.name` form, to act as "i18n escape hatches"'';
                            };

                            ignore-tests = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore test files";
                            };

                            watch-for-scripts = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of Unicode scripts to watch for any usage in string literals";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    govet = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            settings = lib.mkOption {
                              type = types.nullOr (types.attrsOf types.unspecified);
                              default = null;
                              description = "Settings per analyzer. Map of analyzer name to specific settings. Run `go tool vet help` to find out more.";
                            };

                            enable = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Enable analyzers by name";
                            };

                            disable = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Disable analyzers by name";
                            };

                            enable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable all analyzers";
                            };

                            disable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disable all analyzers";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    grouper = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            const-require-single-const = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that constants are defined in a single const block";
                            };

                            const-require-grouping = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that constants are defined in a group";
                            };

                            import-require-single-import = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that imports are defined in a single import block";
                            };

                            import-require-grouping = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that imports are defined in a group";
                            };
                            type-require-single-type = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that types are defined in a single type block";
                            };

                            type-require-grouping = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that types are defined in a group";
                            };
                            var-require-single-var = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that variables are defined in a single var block";
                            };

                            var-require-grouping = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require that variables are defined in a group";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    iface = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            enable = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Enable analyzers by name";
                            };
                            settings = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    unused = lib.mkOption {
                                      type = types.nullOr (
                                        types.submodule {
                                          options = {
                                            exclude = lib.mkOption {
                                              type = types.nullOr (types.listOf types.str);
                                              default = null;
                                              description = "List of regular expressions to exclude unused interfaces from check";
                                            };
                                          };
                                        }
                                      );
                                      default = null;
                                      description = "Settings for the unused analyzer";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings per analyzer. Map of analyzer name to specific settings";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    importas = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            no-unaliased = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Do not allow unaliased imports of aliased packages";
                            };

                            no-extra-aliases = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Do not allow non-required aliases";
                            };

                            alias = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      pkg = lib.mkOption {
                                        type = types.str;
                                        description = "Package path e.g. knative.dev/serving/pkg/apis/autoscaling/v1alpha1";
                                      };

                                      alias = lib.mkOption {
                                        type = types.str;
                                        description = "Package alias e.g. autoscalingv1alpha1";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "List of aliases";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    inamedparam = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            skip-single-param = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Skips check for interface methods with only a single parameter";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    ireturn = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            allow = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of allowed interfaces";
                            };
                            reject = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of interfaces to reject";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    lll = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            tab-width = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = ''Width of \t in spaces'';
                            };

                            line-length = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Maximum allowed line length, lines longer will be reported";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    maintidx = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            under = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Minimum acceptable maintainability index level (see https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    makezero = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            always = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow only slices initialized with a length of zero";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    loggercheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            kitlog = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow check for the github.com/go-kit/log library.";
                            };

                            klog = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow check for the k8s.io/klog/v2 library.";
                            };

                            logr = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow check for the github.com/go-logr/logr library.";
                            };

                            zap = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''Allow check for the "sugar logger" from go.uber.org/zap library.'';
                            };

                            require-string-key = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require all logging keys to be inlined constant strings.";
                            };

                            no-printf-like = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Require printf-like format specifier (%s, %d for example) not present.";
                            };

                            rules = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of custom rules to check against, where each rule is a single logger pattern, useful for wrapped loggers.";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    misspell = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            locale = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "US"
                                  "UK"
                                  ""
                                ]
                              );
                              default = null;
                              description = "Correct spellings using locale preferences for US or UK. Default is to use a neutral variety of English.";
                            };

                            ignore-words = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of words to ignore";
                            };

                            mode = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "restricted"
                                  ""
                                  "default"
                                ]
                              );
                              default = null;
                              description = "Mode of the analysis";
                            };

                            extra-words = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      correction = lib.mkOption {
                                        type = types.str;
                                        description = "Corrected word";
                                      };
                                      typo = lib.mkOption {
                                        type = types.str;
                                        description = "Misspelled word";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "Extra word corrections";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    musttag = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            functions = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      name = lib.mkOption {
                                        type = types.str;
                                        description = "Function name";
                                      };
                                      tag = lib.mkOption {
                                        type = types.str;
                                        description = "Tag name";
                                      };
                                      arg-pos = lib.mkOption {
                                        type = types.nullOr types.int;
                                        default = null;
                                        description = "Position of the argument the tag applies to";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "List of functions to require a tag for.";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nakedret = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            max-func-lines = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Report if a function has more lines of code than this value and it has naked returns";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nestif = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            min-complexity = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = ''Minimum complexity of "if" statements to report'';
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nilnil = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            detect-opposite = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "In addition, detect opposite situation (simultaneous return of non-nil error and valid value)";
                            };

                            checked-types = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "chan"
                                    "func"
                                    "iface"
                                    "map"
                                    "ptr"
                                    "uintptr"
                                    "unsafeptr"
                                  ]
                                )
                              );
                              default = null;
                              description = "List of return types to check";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nlreturn = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            block-size = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Set block size that is still ok";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    mnd = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            ignored-files = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of file patterns to exclude from analysis";
                            };

                            ignored-functions = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Comma-separated list of function patterns to exclude from the analysis";
                            };

                            ignored-numbers = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of numbers to exclude from analysis";
                            };

                            checks = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "argument"
                                    "case"
                                    "condition"
                                    "operation"
                                    "return"
                                    "assign"
                                  ]
                                )
                              );
                              default = null;
                              description = "The list of enabled checks, see https://github.com/tommy-muehle/go-mnd/#checks for description";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nolintlint = lib.mkOption {
                      default = null;
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            allow-unused = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable to ensure that nolint directives are all used";
                            };

                            allow-no-explanation = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Exclude these linters from requiring an explanation";
                            };

                            require-explanation = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable to require an explanation of nonzero length after each nolint directive";
                            };

                            require-specific = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable to require nolint directives to mention the specific linter being suppressed";
                            };
                          };
                        }
                      );
                    };

                    reassign = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            patterns = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of patterns for variable reassignments";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    nonamedreturns = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            report-error-in-defer = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report named error if it is assigned inside defer";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    paralleltest = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            ignore-missing = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore missing calls to `t.Parallel()` and only report incorrect uses of it";
                            };
                            ignore-missing-subtests = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore missing calls to `t.Parallel()` in subtests. Top-level tests are still required to have `t.Parallel`, but subtests are allowed to skip it.";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    perfsprint = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            int-conversion = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Optimizes even if it requires an int or uint type cast";
                            };

                            err-error = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Optimizes into `err.Error()` even if it is only equivalent for non-nil errors";
                            };

                            errorf = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Optimizes `fmt.Errorf`";
                            };

                            sprintf1 = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Optimizes `fmt.Sprintf` with only one argument";
                            };

                            strconcat = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Optimizes into strings concatenation";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    prealloc = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            simple = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report preallocation suggestions only on simple loops that have no returns/breaks/continues/gotos in them";
                            };

                            range-loops = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report preallocation suggestions on range loops";
                            };

                            for-loops = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Report preallocation suggestions on for loops";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    predeclared = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            ignore = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Comma-separated list of predeclared identifiers to not report on";
                            };
                            q = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Include method names and field names (i.e., qualified names) in checks";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    promlinter = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            strict = lib.mkOption {
                              type = types.nullOr types.unspecified;
                              default = null;
                              description = "Strict mode for labels";
                            };
                            disabled-linters = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "Help"
                                    "MetricUnits"
                                    "Counter"
                                    "HistogramSummaryReserved"
                                    "MetricTypeInName"
                                    "ReservedChars"
                                    "CamelCase"
                                    "UnitAbbreviations"
                                  ]
                                )
                              );
                              default = null;
                              description = "List of linters to disable";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    protogetter = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            skip-generated-by = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of strings that if ANY is found as comment, any generated file is skipped";
                            };
                            skip-files = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of files to skip";
                            };

                            skip-any-generated = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Skip any generated files from the checking";
                            };
                            replace-first-arg-in-append = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Skip first argument of append function";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    revive = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            max-open-files = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Max open files limit";
                            };
                            ignore-generated-header = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore generated header";
                            };
                            confidence = lib.mkOption {
                              type = types.nullOr types.float;
                              default = null;
                              description = "Confidence level";
                            };

                            severity = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "warning"
                                  "error"
                                ]
                              );
                              default = null;
                              description = "Severity level";
                            };
                            enable-all-rules = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable all rules, this will not respect excludes";
                            };
                            rules = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.submodule {
                                    options = {
                                      name = lib.mkOption {
                                        type = types.str;
                                        description = "Rule name";
                                      };
                                      disabled = lib.mkOption {
                                        type = types.nullOr types.bool;
                                        default = null;
                                        description = "Disable rule";
                                      };
                                      severity = lib.mkOption {
                                        type = types.nullOr (
                                          types.enum [
                                            "warning"
                                            "error"
                                          ]
                                        );
                                        default = null;
                                        description = "Severity of the rule";
                                      };
                                      exclude = lib.mkOption {
                                        type = types.nullOr (types.listOf types.str);
                                        default = null;
                                        description = "Exclude patterns";
                                      };
                                      arguments = lib.mkOption {
                                        type = types.nullOr (types.listOf types.unspecified);
                                        default = null;
                                        description = "Arguments to be passed to the rule";
                                      };
                                    };
                                  }
                                )
                              );
                              default = null;
                              description = "Rules to enable or disable";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    rowserrcheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            packages = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of packages to check";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    sloglint = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            kv-only = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce using key-value pairs only (incompatible with attr-only)";
                            };

                            no-global = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  ""
                                  "all"
                                  "default"
                                ]
                              );
                              default = null;
                              description = "Enforce not using global loggers";
                            };

                            no-mixed-args = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce not mixing key-value pairs and attributes";
                            };

                            context = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  ""
                                  "all"
                                  "scope"
                                ]
                              );
                              default = null;
                              description = "Enforce using methods that accept a context";
                            };

                            static-msg = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce using static values for log messages";
                            };

                            key-naming-case = lib.mkOption {
                              type = types.nullOr (
                                types.enum [
                                  "snake"
                                  "kebab"
                                  "camel"
                                  "pascal"
                                ]
                              );
                              default = null;
                              description = "Enforce a single key naming convention";
                            };

                            attr-only = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce using attributes only (incompatible with kv-only)";
                            };

                            no-raw-keys = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce using constants instead of raw keys";
                            };

                            forbidden-keys = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Enforce not using specific keys";
                            };
                            args-on-sep-lines = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforce putting arguments on separate lines";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    spancheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            checks = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "end"
                                    "record-error"
                                    "set-status"
                                  ]
                                )
                              );
                              default = null;
                              description = "Checks to enable";
                            };

                            "ignore-check-signatures" = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "A list of regexes for function signatures that silence `record-error` and `set-status` reports if found in the call path to a returned error";
                            };

                            "extra-start-span-signatures" = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "A list of regexes for additional function signatures that create spans";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    staticcheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            checks = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Checks to include in analysis. `all` is also accepted";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    stylecheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            checks = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Checks to enable";
                            };

                            dot-import-whitelist = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "By default, ST1001 forbids all uses of dot imports in non-test packages. This setting allows setting a whitelist of import paths that can be dot-imported anywhere";
                            };

                            http-status-code-whitelist = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "100"
                                    "101"
                                    "102"
                                    "103"
                                    "200"
                                    "201"
                                    "202"
                                    "203"
                                    "204"
                                    "205"
                                    "206"
                                    "207"
                                    "208"
                                    "226"
                                    "300"
                                    "301"
                                    "302"
                                    "303"
                                    "304"
                                    "305"
                                    "306"
                                    "307"
                                    "308"
                                    "400"
                                    "401"
                                    "402"
                                    "403"
                                    "404"
                                    "405"
                                    "406"
                                    "407"
                                    "408"
                                    "409"
                                    "410"
                                    "411"
                                    "412"
                                    "413"
                                    "414"
                                    "415"
                                    "416"
                                    "417"
                                    "418"
                                    "421"
                                    "422"
                                    "423"
                                    "424"
                                    "425"
                                    "426"
                                    "428"
                                    "429"
                                    "431"
                                    "451"
                                    "500"
                                    "501"
                                    "502"
                                    "503"
                                    "504"
                                    "505"
                                    "506"
                                    "507"
                                    "508"
                                    "510"
                                    "511"
                                  ]
                                )
                              );
                              default = null;
                              description = ''
                                ST1013 recommends using constants from the net/http package
                                instead of hard-coding numeric HTTP status codes. This setting
                                specifies a list of numeric status codes that this check does
                                not complain about.
                              '';
                            };

                            initialisms = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "ST1003 check, among other things, for the correct capitalization of initialisms. The set of known initialisms can be configured with this option";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    tagalign = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            align = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Align and sort can be used together or separately";
                            };
                            sort = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Whether enable tags sort";
                            };
                            order = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Specify the order of tags, the other tags will be sorted by name";
                            };
                            strict = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Whether enable strict style";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    tagliatelle = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            case = lib.mkOption {
                              type = types.submodule {
                                options = {
                                  use-field-name = lib.mkOption {
                                    type = types.nullOr types.bool;
                                    default = null;
                                    description = "Use the struct field name to check the name of the struct tag";
                                  };

                                  rules = lib.mkOption {
                                    type = types.nullOr (
                                      types.attrsOf (
                                        types.enum [
                                          "camel"
                                          "pascal"
                                          "kebab"
                                          "snake"
                                          "goCamel"
                                          "goPascal"
                                          "goKebab"
                                          "goSnake"
                                          "upper"
                                          "upperSnake"
                                          "lower"
                                          "header"
                                        ]
                                      )
                                    );
                                    default = null;
                                    description = "Case rules";
                                  };
                                };
                              };
                              default = null;
                              description = "Case settings";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    tenv = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "The option `all` will run against whole test files (`_test.go`) regardless of method/function signatures";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    testifylint = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            enable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enable all checkers";
                            };

                            disable-all = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Disable all checkers";
                            };

                            enable = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "blank-import"
                                    "bool-compare"
                                    "compares"
                                    "contains"
                                    "empty"
                                    "encoded-compare"
                                    "error-is-as"
                                    "error-nil"
                                    "expected-actual"
                                    "float-compare"
                                    "formatter"
                                    "go-require"
                                    "len"
                                    "negative-positive"
                                    "nil-compare"
                                    "regexp"
                                    "require-error"
                                    "suite-broken-parallel"
                                    "suite-dont-use-pkg"
                                    "suite-extra-assert-call"
                                    "suite-subtest-run"
                                    "suite-thelper"
                                    "useless-assert"
                                  ]
                                )
                              );
                              default = null;
                              description = "Enable specific checkers";
                            };

                            disable = lib.mkOption {
                              type = types.nullOr (
                                types.listOf (
                                  types.enum [
                                    "blank-import"
                                    "bool-compare"
                                    "compares"
                                    "contains"
                                    "empty"
                                    "encoded-compare"
                                    "error-is-as"
                                    "error-nil"
                                    "expected-actual"
                                    "float-compare"
                                    "formatter"
                                    "go-require"
                                    "len"
                                    "negative-positive"
                                    "nil-compare"
                                    "regexp"
                                    "require-error"
                                    "suite-broken-parallel"
                                    "suite-dont-use-pkg"
                                    "suite-extra-assert-call"
                                    "suite-subtest-run"
                                    "suite-thelper"
                                    "useless-assert"
                                  ]
                                )
                              );
                              default = null;
                              description = "Disable specific checkers";
                            };

                            bool-compare = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    ignore-custom-types = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "To ignore user defined types (over builtin bool)";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the bool-compare checker";
                            };

                            expected-actual = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    pattern = lib.mkOption {
                                      type = types.nullOr types.str;
                                      default = null;
                                      description = "Regexp for expected variable name";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the expected-actual checker";
                            };

                            formatter = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    check-format-string = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "To enable go vet's printf checks";
                                    };

                                    require-f-funcs = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "To require f-assertions (e.g. assert.Equalf) if format string is used, even if there are no variable-length variables";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the formatter checker";
                            };

                            go-require = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    ignore-http-handlers = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "To ignore HTTP handlers (like http.HandlerFunc)";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the go-require checker";
                            };

                            require-error = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    fn-pattern = lib.mkOption {
                                      type = types.nullOr types.str;
                                      default = null;
                                      description = "Regexp for assertions to analyze. If defined, then only matched error assertions will be reported";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the require-error checker";
                            };

                            suite-extra-assert-call = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    mode = lib.mkOption {
                                      type = types.nullOr (
                                        types.enum [
                                          "remove"
                                          "require"
                                        ]
                                      );
                                      default = null;
                                      description = "To require or remove extra Assert() call?";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for the suite-extra-assert-call checker";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    testpackage = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            skip-regexp = lib.mkOption {
                              type = types.nullOr types.str;
                              default = null;
                              description = "Files with names matching this regular expression are skipped";
                            };
                            allow-packages = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "List of packages that don't end with _test that tests are allowed to be in";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    thelper = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            test = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    begin = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if `t.Helper()` begins helper function";
                                    };

                                    first = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.T is first param of helper function";
                                    };

                                    name = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.T param has t name";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for test helpers";
                            };

                            benchmark = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    begin = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if `b.Helper()` begins helper function";
                                    };

                                    first = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.B is first param of helper function";
                                    };

                                    name = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.B param has b name";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for benchmark helpers";
                            };

                            tb = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    begin = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if `tb.Helper()` begins helper function";
                                    };

                                    first = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.TB is first param of helper function";
                                    };

                                    name = lib.mkOption {
                                      type = types.nullOr types.bool;
                                      default = null;
                                      description = "Check if *testing.TB param has tb name";
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for testing.TB helpers";
                            };

                            fuzz = lib.mkOption {
                              type = types.nullOr (
                                types.submodule {
                                  options = {
                                    begin = lib.mkOption {
                                      default = null;
                                      description = "Check if `f.Helper()` begins helper function";
                                      type = types.nullOr types.bool;
                                    };

                                    first = lib.mkOption {
                                      default = null;
                                      description = "Check if *testing.F is first param of helper function";
                                      type = types.nullOr types.bool;
                                    };

                                    name = lib.mkOption {
                                      default = null;
                                      description = "Check if *testing.F param has f name";
                                      type = types.nullOr types.bool;
                                    };
                                  };
                                }
                              );
                              default = null;
                              description = "Settings for fuzz helpers";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    usestdlibvars = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            http-method = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of http.MethodXX";
                            };

                            http-status-code = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of http.StatusXX";
                            };

                            time-weekday = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of time.Weekday.String()";
                            };

                            time-month = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of time.Month.String()";
                            };

                            time-layout = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of time.Layout";
                            };

                            crypto-hash = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of crypto.Hash.String()";
                            };

                            default-rpc-path = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of rpc.DefaultXXPath";
                            };

                            sql-isolation-level = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of sql.LevelXX.String()";
                            };
                            tls-signature-scheme = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of tls.SignatureScheme.String()";
                            };
                            constant-kind = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Suggest the use of constant.Kind.String()";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    unconvert = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            fast-math = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow floating point conversions that may result in loss of precision";
                            };
                            safe = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Restrict conversions to safe conversions only";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    unparam = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            check-exported = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = ''
                                Inspect exported functions. Set to true if no external
                                program/library imports your code.

                                WARNING: if you enable this setting, unparam will report a lot
                                of false-positives in text editors:
                                if it's called for subdir of a project it can't find external
                                interfaces. All text editor integrations
                                with golangci-lint call it on a directory with the changed
                                file.
                              '';
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    unused = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            field-writes-are-uses = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider field writes as uses";
                            };
                            post-statements-are-reads = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider post statements in for loops as reads of loop variables";
                            };
                            exported-fields-are-used = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider exported fields as used";
                            };
                            parameters-are-used = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider function parameters as used";
                            };
                            local-variables-are-used = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider local variables as used";
                            };
                            generated-is-used = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Consider generated code as used";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    varnamelen = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            max-distance = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Variables used in at most this N-many lines will be ignored";
                            };

                            min-name-length = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "The minimum length of a variable's name that is considered `long`";
                            };

                            check-receiver = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check method receiver names";
                            };

                            check-return = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check named return values";
                            };

                            check-type-param = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check type parameters";
                            };

                            ignore-type-assert-ok = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore `ok` variables that hold the bool return value of a type assertio";
                            };

                            ignore-map-index-ok = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore `ok` variables that hold the bool return value of a map index";
                            };

                            ignore-chan-recv-ok = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Ignore `ok` variables that hold the bool return value of a channel receive";
                            };

                            ignore-names = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Optional list of variable names that should be ignored completely";
                            };

                            ignore-decls = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "Optional list of variable declarations that should be ignored completely";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    whitespace = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            multi-if = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforces newlines (or comments) after every multi-line if statement";
                            };

                            multi-func = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Enforces newlines (or comments) after every multi-line function signature";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    wrapcheck = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            ignoreSigs = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "An array of strings which specify substrings of signatures to ignore";
                            };

                            ignoreSigRegexps = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "An array of strings which specify regular expressions of signatures to ignore";
                            };

                            ignorePackageGlobs = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "An array of glob patterns which, if any match the package of the function returning the error, will skip wrapcheck analysis for this error";
                            };
                            ignoreInterfaceRegexps = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "An array of glob patterns which, if matched to an underlying interface name, will ignore unwrapped errors returned from a function whose call is defined on the given interface";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    wsl = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            allow-assign-and-anything = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Controls if you may cuddle assignments and anything without needing an empty line between them";
                            };

                            allow-assign-and-call = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow calls and assignments to be cuddled as long as the lines have any matching variables, fields or types";
                            };

                            allow-cuddle-declarations = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow declarations (var) to be cuddled";
                            };

                            allow-cuddle-with-calls = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "A list of call idents that everything can be cuddled with";
                            };

                            allow-cuddle-with-rhs = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "AllowCuddleWithRHS is a list of right hand side variables that is allowed to be cuddled with anything";
                            };

                            allow-multiline-assign = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow multiline assignments to be cuddled";
                            };

                            allow-separated-leading-comment = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow leading comments to be separated with empty lines";
                            };

                            allow-trailing-comment = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Allow trailing comments in ending of blocks";
                            };

                            error-variable-names = lib.mkOption {
                              type = types.nullOr (types.listOf types.str);
                              default = null;
                              description = "When force-err-cuddling is enabled this is a list of names used for error variables to check for in the conditional";
                            };

                            force-case-trailing-whitespace = lib.mkOption {
                              type = types.nullOr types.int;
                              default = null;
                              description = "Force newlines in end of case at this limit (0 = never)";
                            };

                            force-err-cuddling = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Causes an error when an If statement that checks an error variable doesn't cuddle with the assignment of that variable";
                            };

                            force-short-decl-cuddling = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Causes an error if a short declaration (:=) cuddles with anything other than another short declaration";
                            };

                            strict-append = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "If true, append is only allowed to be cuddled if appending value is matching variables, fields or types on line above";
                            };
                          };
                        }
                      );
                      default = null;
                    };

                    copyloopvar = lib.mkOption {
                      type = types.nullOr (
                        types.submodule {
                          options = {
                            check-alias = lib.mkOption {
                              type = types.nullOr types.bool;
                              default = null;
                              description = "Check alias of loop variables";
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
            };

            linters = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "List of enabled linters";
                    };

                    disable = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "List of disabled linters";
                    };

                    enable-all = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Whether to enable all linters. You can re-disable them with `disable` explicitly";
                    };

                    disable-all = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Whether to disable all linters. You can re-enable them with `enable` explicitly";
                    };

                    presets = lib.mkOption {
                      type = types.nullOr (
                        types.listOf (
                          types.enum [
                            "bugs"
                            "comment"
                            "complexity"
                            "error"
                            "format"
                            "import"
                            "metalinter"
                            "module"
                            "performance"
                            "sql"
                            "style"
                            "test"
                            "unused"
                          ]
                        )
                      );
                      default = null;
                      description = " Allow to use different presets of linters";
                    };

                    fast = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Enable run of fast linters";
                    };
                  };
                }
              );
              default = null;
            };

            issues = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    exclude = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "Regular expressions of issue texts to exclude";
                    };

                    exclude-rules = lib.mkOption {
                      type = types.nullOr (
                        types.listOf (
                          types.submodule {
                            options = {
                              path = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              path-except = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              linters = lib.mkOption {
                                type = types.nullOr (types.listOf types.str);
                                default = null;
                              };
                              text = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              source = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                            };
                          }
                        )
                      );
                      default = null;
                      description = "Fine-grained issue exclusion rules";
                    };

                    exclude-use-default = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = " Independently from option `exclude` we use default exclude patterns. This behavior can be disabled by this option.";
                    };

                    exclude-case-sensitive = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "If set to true, exclude and exclude-rules regular expressions become case sensitive";
                    };

                    exclude-generated = lib.mkOption {
                      type = types.nullOr (
                        types.enum [
                          "lax"
                          "strict"
                          "disable"
                        ]
                      );
                      default = null;
                      description = "Mode of the generated files analysis";
                    };

                    exclude-dirs = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "Which directories to exclude: issues from them won't be reported";
                    };

                    exclude-dirs-use-default = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = ''Enable exclusion of directories " vendor ", " third_party "," "testdata", "examples", "Godeps", and "builtin"'';
                    };

                    exclude-files = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "Which files to exclude: they will be analyzed, but issues from them will not be reported";
                    };

                    include = lib.mkOption {
                      type = types.nullOr (types.listOf types.str);
                      default = null;
                      description = "The list of ids of default excludes to include or disable";
                    };

                    max-issues-per-linter = lib.mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = "Maximum issues per linter";
                    };

                    max-same-issues = lib.mkOption {
                      type = types.nullOr types.int;
                      default = null;
                      description = "Maximum count of issues with the same text";
                    };

                    new = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Show only new issues";
                    };

                    new-from-rev = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Show only new issues created after this git revision";
                    };

                    new-from-patch = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Show only new issues created in git patch with this file path";
                    };

                    fix = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Fix found issues (if supported)";
                    };

                    whole-files = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "Show issues in whole update files, requires new-from-rev or new-from-patch";
                    };
                  };
                }
              );
              default = null;
            };

            severity = lib.mkOption {
              type = types.nullOr (
                types.submodule {
                  options = {
                    default-severity = lib.mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Default severity for issues not matching any rule";
                    };

                    case-sensitive = lib.mkOption {
                      type = types.nullOr types.bool;
                      default = null;
                      description = "If set to true, severity-rules regular expressions become case sensitive";
                    };

                    rules = lib.mkOption {
                      type = types.nullOr (
                        types.listOf (
                          types.submodule {
                            options = {
                              severity = lib.mkOption { type = types.str; };
                              path = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              path-except = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              linters = lib.mkOption {
                                type = types.nullOr (types.listOf types.str);
                                default = null;
                              };
                              text = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                              source = lib.mkOption {
                                type = types.nullOr types.str;
                                default = null;
                              };
                            };
                          }
                        )
                      );
                      default = null;
                    };
                  };
                }
              );
              default = null;
            };
          };
        };
      apply = unit.lib.attrsets.removeNullAttrs;
    };
  });
}
