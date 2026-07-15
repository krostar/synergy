/*
Golden tests: each file generator must render byte-identical output for a
representative configuration. To update a golden file after an intentional
change, build the failing check and copy the rendered file over the
corresponding _testdata/*.golden.
*/
{
  pkgs,
  unit,
  ...
}: let
  render = assertion: file: data: golden:
    pkgs.testers.testEqualContents {
      inherit assertion;
      actual = (unit.lib.nixago.make {inherit pkgs file data;}).configFile;
      # round-trip the golden through writeText so both sides are built
      # store files; a raw source path differs in stat metadata (group),
      # which diffoscope would report as a difference
      expected = pkgs.writeText (baseNameOf golden) (builtins.readFile golden);
    };
in {
  justfile =
    render "lib.nixago.files.justfile golden render" unit.lib.nixago.files.justfile {
      enable = true;
      imports = ["justfiles/extra.just"];
      settings = {
        positional-arguments = "true";
        shell = ''["bash", "-uec"]'';
      };
      pre-recipes = "# pre section";
      default = "@just --list";
      recipes = {
        build = {
          enable = true;
          aliases = ["b"];
          comment = "build the project";
          groups = ["dev" "ci"];
          recipe = "cargo build";
        };
        disabled = {
          enable = false;
          aliases = [];
          recipe = "echo nope";
        };
        test = {
          enable = true;
          aliases = [];
          documentation = "run the tests";
          attributes = ["no-cd"];
          parameters = ["target='all'"];
          dependencies = ["build"];
          recipe = ''
            echo "testing {{target}}"
            cargo test'';
        };
      };
      post-recipes = "# post section";
    }
    ./_testdata/justfile.golden;

  editorconfig =
    render "lib.nixago.files.editorconfig golden render" unit.lib.nixago.files.editorconfig {
      settings = {
        root = true;
        "*" = {
          end_of_line = "lf";
          indent_style = "space";
        };
        "*.md" = {
          trim_trailing_whitespace = false;
        };
      };
    }
    ./_testdata/editorconfig.golden;

  intellij-idea-file-watchers =
    render "lib.nixago.files.intellij-idea.file-watchers golden render" unit.lib.nixago.files.intellij-idea.file-watchers [
      {
        enabled = true;
        name = "alejandra";
        scope = "Project Files";
        fileExtension = "nix";
        workingDir = "$ProjectFileDir$";
        program = "alejandra";
        arguments = "$FilePath$";
        output = "$FilePath$";
      }
      {
        enabled = false;
        name = "disabled";
        scope = "Project Files";
        fileExtension = "go";
        workingDir = "$ProjectFileDir$";
        program = "gofmt";
        arguments = "$FilePath$";
        output = "$FilePath$";
      }
    ]
    ./_testdata/intellij-file-watchers.golden;

  yamllint =
    render "lib.nixago.files.yamllint golden render" unit.lib.nixago.files.yamllint {
      extends = "default";
      ignore = ["vendor/"];
      rules = {
        line-length = {max = 120;};
      };
    }
    ./_testdata/yamllint.golden;

  commitlint =
    render "lib.nixago.files.commitlint golden render" unit.lib.nixago.files.commitlint {
      extends = ["@commitlint/config-conventional"];
      rules = {
        body-max-line-length = [2 "always" 100];
      };
    }
    ./_testdata/commitlint.golden;
}
