/*
Compatibility check: a raw nixago-style request (functor attribute, omitted
format/engine, hook.extra as a function of pre-apply data, copy mode) must
keep working through the vendored make/makeAll implementations.
*/
{
  pkgs,
  unit,
  ...
}: let
  functorRequest = {
    __functor = _: throw "__functor must be stripped from requests";
    data.a.b = 1;
    # `format` omitted: must be inferred as "json" from the extension
    output = "generated/test.json";
    apply = data: data // {applied = true;};
    hook = {
      # must receive the RAW pre-apply data, so `applied` is absent
      extra = raw: "echo extra saw applied=${builtins.toJSON (raw ? applied)}";
      mode = "copy";
    };
  };

  made = unit.lib.nixago.make {
    inherit pkgs;
    config = functorRequest;
  };

  cueMade = unit.lib.nixago.make {
    inherit pkgs;
    config = {
      data.hello = "world";
      output = "generated/test.yaml";
      engine = (unit.lib.nixago.engines pkgs).cue {files = [];};
    };
  };

  all = unit.lib.nixago.makeAll {
    inherit pkgs;
    configs = [functorRequest];
    log = false;
  };

  allShellHook = pkgs.writeText "makeall-shellhook" all.shellHook;
in
  pkgs.runCommand "lib-nixago-compat" {} ''
    grep -qF '"applied": true' ${made.configFile}
    grep -qF 'extra saw applied=false' ${made.shellScript}
    grep -qF 'cmp' ${made.shellScript}
    grep -qF 'hello: world' ${cueMade.configFile}
    grep -qF 'NIXAGO_LOG=0' ${allShellHook}
    test ${builtins.toString (builtins.length all.configs)} -eq 1
    touch $out
  ''
