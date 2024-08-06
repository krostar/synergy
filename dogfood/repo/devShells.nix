{
  pkgs,
  self,
  ...
}:
pkgs.mkShellNoCC {
  nativeBuildInputs = [self.formatter];
}
