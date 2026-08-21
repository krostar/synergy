{pkgs, ...}: {
  enable = true;
  package = pkgs.treefmt;
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    buf.enable = true;
    formatjson5.enable = true;
    just.enable = true;
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
      plugins = p: [
        p.mdformat-beautysh
        p.mdformat-gfm
        p.mdformat-nix-alejandra
      ];
      settings.number = true;
    };
    mdsh.enable = true;
    shfmt.enable = true;
    yamlfmt.enable = true;
  };
  settings.formatter = {
    gci.priority = 1;
    goimports.priority = 3;
    gofumpt.priority = 2;
    yamlfmt.options = ["-formatter" "include_document_start=true,trim_trailing_whitespace=true,retain_line_breaks_single=true"];
  };
}
