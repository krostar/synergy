{
  issues = {
    exclude-rules = [
      {
        path = "_test\\.go";
        linters = [
          "dupl"
          "errcheck"
          "errorlint"
          "gosec"
          "noctx"
          "nonamedreturns"
        ];
      }
      {
        path = "_test\\.go";
        linters = ["revive"];
        text = "context-keys-type|nested-structs|unchecked-type-assertion";
      }
      {
        path = "_test\\.go";
        linters = ["staticcheck"];
        text = "SA1029";
      }
    ];
    exclude-use-default = false;
    max-issues-per-linter = 0;
    max-same-issues = 0;
  };

  linters-settings = {
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
      check-blank = true;
      exclude-functions = [
        "io.ReadAll"
        "(io.ReadCloser).Close"
        "encoding/json.Marshal"
        "encoding/json.MarshalIndent"
      ];
    };
    errchkjson = {
      check-error-free-encoding = true;
      report-no-exported = true;
    };
    errorlint = {
      errorf = false;
    };
    gci = {
      custom-order = true;
      sections = [
        "standard"
        "default"
        "Prefix(github.com/krostar/)"
        "localmodule"
      ];
    };
    goconst = {
      ignore-tests = true;
    };
    gocritic = {
      disabled-checks = ["ifElseChain"];
    };
    godot = {
      capital = true;
      period = true;
      scope = "toplevel";
    };
    gofumpt = {
      extra-rules = true;
    };
    govet = {
      disable = ["fieldalignment"];
      enable-all = true;
    };
    grouper = {
      import-require-single-import = true;
    };
    importas = {
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
      no-extra-aliases = true;
    };
    misspell = {
      locale = "US";
    };
    nolintlint = {
      require-explanation = true;
      require-specific = true;
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
          arguments = [["call-chain" "loop" "recover" "immediate-recover" "return"]];
        }
        {
          name = "empty-lines";
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
          arguments = [3];
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
      forbidden-keys = [
        "time"
        "level"
        "msg"
        "source"
      ];
    };
    stylecheck = {
      checks = ["all" "-ST1000" "ST1020" "ST1021" "ST1022"];
    };
    tagliatelle = {
      case = {
        rules = {
          json = "snake";
          yaml = "kebab";
        };
      };
    };
    whitespace = {
      multi-func = true;
    };
  };

  linters = {
    enable-all = true;
    disable = [
      "bodyclose"
      "cyclop"
      "decorder"
      "dogsled"
      "err113"
      "exhaustruct"
      "exportloopref"
      "forbidigo"
      "forcetypeassert"
      "funlen"
      "ginkgolinter"
      "gocognit"
      "gocyclo"
      "goheader"
      "ireturn"
      "lll"
      "loggercheck"
      "maintidx"
      "makezero"
      "mnd"
      "nlreturn"
      "paralleltest"
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
  };
}
