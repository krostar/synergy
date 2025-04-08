{pkgs, ...}: {
  package = pkgs.treefmt;
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    cue.enable = true;
    formatjson5.enable = true;
    gci = {
      enable = true;
      order = ["standard" "default" "localmodule"];
    };
    gofumpt = {
      enable = true;
      extra = true;
    };
    goimports.enable = true;
    mdformat = {
      enable = true;
    };
    mdsh.enable = true;
    shfmt.enable = true;
    yamlfmt.enable = true;
  };
  settings.formatter = {
    yamlfmt.options = ["-formatter" "include_document_start=true,trim_trailing_whitespace=true,retain_line_breaks_single=true"];
    gci.priority = 1;
    goimports.priority = 3;
    gofumpt.priority = 2;
  };
}
