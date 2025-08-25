{lib, ...}: {
  enable = lib.mkDefault false;
  version = "2";

  issues = {
    max-issues-per-linter = 0;
    max-same-issues = 0;
  };

  linters = {
    default = "all";

    disable = [
      "bodyclose"
      "cyclop"
      "decorder"
      "dogsled"
      "err113"
      "exhaustruct"
      "forbidigo"
      "forcetypeassert"
      "funlen"
      "ginkgolinter"
      "gocognit"
      "gocyclo"
      "godot"
      "goheader"
      "ireturn"
      "lll"
      "loggercheck"
      "maintidx"
      "makezero"
      "mnd"
      "nlreturn"
      "noinlineerr"
      "prealloc"
      "promlinter"
      "testpackage"
      "thelper"
      "tparallel"
      "varnamelen"
      "wrapcheck"
      "wsl"
      "zerologlint"
    ];

    settings = {
      copyloopvar = {
        check-alias = true;
      };

      depguard = {
        rules = {
          all = {
            list-mode = "lax";
            deny = [
              {
                pkg = "reflect";
                desc = "by default reflect import is prohibited due to the high level of complexity it brings into the code";
              }
              {
                pkg = "github.com/pkg/errors";
                desc = "use go1.13 errors";
              }
              {
                pkg = "math/rand$";
                desc = "math/rand now has a v2, see https://go.dev/blog/randv2";
              }
            ];
          };
          test = {
            files = ["$test"];
            list-mode = "lax";
            deny = [
              {
                pkg = "github.com/stretchr/testify";
                desc = "testing should be done using github.com/krostar/test";
              }
              {
                pkg = "gotest.tools/v3/assert";
                desc = "testing should be done using github.com/krostar/test";
              }
            ];
          };
        };
      };

      errcheck = {
        check-type-assertions = true;
        check-blank = true;
        exclude-functions = [
          "(io.ReadCloser).Close"
          "(*os.File).Close"
          "encoding/json.Marshal"
          "encoding/json.MarshalIndent"
          "io.ReadAll"
        ];
      };

      errchkjson = {
        check-error-free-encoding = true;
        report-no-exported = true;
      };

      errorlint = {
        errorf = false;
      };

      exhaustive = {
        default-signifies-exhaustive = true;
      };

      gocritic = {
        enable-all = true;
        disabled-checks = ["ifElseChain" "unnamedResult" "unnecessaryBlock"];
      };

      govet = {
        enable-all = true;
        disable = ["fieldalignment"];
      };

      grouper = {
        import-require-single-import = true;
      };

      iface = {
        enable = ["identical" "unused" "opaque"];
      };

      importas = {
        no-unaliased = true;
        alias = [
          {
            pkg = "github.com/google/go-cmp/cmp";
            alias = "gocmp";
          }
          {
            pkg = "github.com/google/go-cmp/cmp/cmpopts";
            alias = "gocmpopts";
          }
        ];
      };

      loggercheck = {
        require-string-key = true;
        no-printf-like = true;
      };

      misspell = {
        locale = "US";
        mode = "restricted";
      };

      nolintlint = {
        require-explanation = true;
        require-specific = true;
      };

      nonamedreturns = {
        report-error-in-defer = true;
      };

      paralleltest = {
        ignore-missing = true;
      };

      reassign = {
        patterns = [".*"];
      };

      revive = {
        enable-all-rules = true;
        rules = [
          {
            name = "add-constant";
            disabled = true;
          }
          {
            name = "argument-limit";
            disabled = true;
          }
          {
            name = "banned-characters";
            disabled = true;
          }
          {
            name = "cognitive-complexity";
            disabled = true;
          }
          {
            name = "confusing-results";
            disabled = true;
          }
          {
            name = "cyclomatic";
            disabled = true;
          }
          {
            name = "defer";
            arguments = [
              [
                "call-chain"
                "loop"
                "recover"
                "immediate-recover"
                "return"
              ]
            ];
          }
          {
            name = "empty-lines";
            disabled = true;
          }
          {
            name = "enforce-switch-style";
            disabled = true;
          }
          {
            name = "file-header";
            disabled = true;
          }
          {
            name = "flag-parameter";
            disabled = true;
          }
          {
            name = "function-length";
            disabled = true;
          }
          {
            name = "function-result-limit";
            arguments = [4];
          }
          {
            name = "line-length-limit";
            disabled = true;
          }
          {
            name = "max-public-structs";
            disabled = true;
          }
          {
            name = "package-comments";
            disabled = true;
          }
          {
            name = "unhandled-error";
            disabled = true;
          }
        ];
      };

      sloglint = {
        no-global = "all";
        context = "scope";
        static-msg = true;
        key-naming-case = "snake";
        forbidden-keys = ["time" "level" "msg" "source"];
      };

      staticcheck = {
        checks = [
          "all"
          "-ST1000"
          "-ST1020"
          "-ST1021"
          "-ST1022"
        ];
      };

      tagliatelle = {
        case.rules = {
          json = "snake";
          yaml = "kebab";
        };
      };

      testifylint = {
        enable-all = true;
      };

      whitespace = {
        multi-func = true;
      };

      wsl_v5 = {
        allow-whole-block = true;
        branch-max-lines = 12;
        disable = [
          "assign-exclusive"
          "assign-expr"
        ];
      };
    };

    exclusions = {
      generated = "lax";
      rules = [
        {
          linters = ["dupl" "errcheck" "errorlint" "gosec" "noctx" "nonamedreturns"];
          path = "_test\\.go";
        }
        {
          linters = ["revive"];
          path = "_test\\.go";
          text = "context-keys-type|nested-structs|unchecked-type-assertion";
        }
        {
          linters = ["staticcheck"];
          path = "_test\\.go";
          text = "SA1029";
        }
        {
          linters = ["goconst"];
          path = "(.+)_test\\.go";
        }
      ];
    };
  };

  formatters = {
    enable = [
      "goimports"
      "gofumpt"
      "gci"
    ];
    settings = {
      gci = {
        sections = [
          "standard"
          "default"
          "localmodule"
        ];
        custom-order = true;
      };
      gofumpt.extra-rules = true;
    };
    exclusions = {
      generated = "lax";
      paths = ["testdata/"];
    };
  };

  run.relative-path-mode = "gomod";
}
