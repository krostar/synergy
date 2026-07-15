# Vendored and adapted from nixago (https://github.com/nix-community/nixago).
# MIT License; Copyright (c) 2022 Joshua Gilman. See ./LICENSE.
/*
Normalizes a nixago-style request attrset, replacing upstream's NixOS-module
based validation (modules/request.nix). Behavior kept for compatibility:
- `__functor` is stripped (functor-style requests are accepted);
- `format` defaults to the extension of `output`;
- unknown attributes (e.g. `root`) are forwarded to the engine untouched.
Extension over upstream: `hook.extra` may also be a list of strings.
*/
{lib}: request: let
  r = builtins.removeAttrs request ["__functor"];

  inferredFormat = let
    parts = lib.strings.splitString "." r.output;
  in
    builtins.elemAt parts (builtins.length parts - 1);

  hookMode = r.hook.mode or "link";

  hookExtra = let
    extra = r.hook.extra or "";
  in
    if builtins.isList extra
    then builtins.concatStringsSep "\n" extra
    else extra;
in
  assert lib.asserts.assertMsg (r ? data) "nixago request: missing required attribute `data`";
  assert lib.asserts.assertMsg (r ? output && builtins.isString r.output) "nixago request: missing required string attribute `output`";
  assert lib.asserts.assertMsg (builtins.elem hookMode ["link" "copy"]) "nixago request: invalid hook.mode `${builtins.toString hookMode}`, valid modes are: link, copy";
    r
    // {
      format = r.format or inferredFormat;
      apply = r.apply or lib.id;
      hook = {
        extra = hookExtra;
        mode = hookMode;
      };
    }
