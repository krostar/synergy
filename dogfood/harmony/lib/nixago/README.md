# nixago

Generates configuration files from Nix data and keeps them in sync in the
repository via shell hooks. This is a vendored, self-contained descendant of
[nixago](https://github.com/nix-community/nixago) (MIT, see
[`_core/LICENSE`](_core/LICENSE)); the upstream project is unmaintained.

## Compatibility guarantee

Any request attrset valid for upstream nixago keeps working here:

```nix
{
  data = { ... };              # required: raw configuration data
  output = "path/to/file.ext"; # required: relative path of the generated file
  format = "yaml";             # optional: defaults to the extension of `output`
  engine = <fn>;               # optional: defaults to the nix engine (pkgs.formats)
  apply = data: data;          # optional: transformation applied to `data`
  hook.mode = "link";          # optional: "link" (default) or "copy"
  hook.extra = "";             # optional: shell run after updates — string, list of strings, or function of the raw data
}
```

Functor-style requests (`__functor`) are accepted, and unknown attributes are
forwarded to the engine untouched. Differences from upstream: `hook.extra` may
be a list of strings, `root` is inert (it was already broken under pure
evaluation upstream), and malformed requests fail with plain assertion
messages instead of module-system diagnostics.

## API (`unit.lib.nixago`, exported downstream as `lib.nixago`)

- `make { pkgs; config; # or: file + data   update ? (cfg: cfg); log ? true; }` →
  `{ configFile, shellHook, shellScript, install }`
- `makeAll { pkgs; configs; log ? true; }` →
  `{ shellHook, scripts, configs }` — rejects duplicate `output` paths
- `engines pkgs` → `{ nix, cue }` — an engine is `opts: request: derivation`;
  custom engines receive the normalized request
- `files.<tool>` — generators with signature `data: pkgs: request`
  (commitlint, editorconfig, git-cliff, justfile, yamllint, ...)
- `appendToShellHooks pkgs shellHooks` — appends the hooks for every entry of
  `data.<system>.dev.nixago` to an existing shellHook string

## Data flow in this repository

1. A data module (e.g. `harmony/data/dev.nix`) renders generators into requests under `data.<system>.dev.nixago.<name>` (schema: `harmony/collectors/data/dev/nixago.nix`).
2. `devShells/base.nix` exports `PRJ_ROOT`, then `appendToShellHooks` turns the collected requests into the dev shell hook. Hooks `cd "$PRJ_ROOT"` before generating, so files always land at the repository root.
3. The `nixago` collector (`harmony/collectors/nixago.nix`) also exposes the raw requests as the `nixago` flake output.

## Hook runtime environment variables

- `NIXAGO_LOG=0` disables logging (`log = false` sets this for you);
  `NIXAGO_LOG_FORMAT` / `DIRENV_LOG_FORMAT` tune the format
- `NIXAGO_TRACE=1` traces hook execution
- `NIXAGO_DEBUG=1` enables debug output

## Layout and tests

- `_core/` — vendored engine/hook/request implementation; the `_` prefix
  hides it from the synergy module loader, it is only reached via relative
  imports from the wrappers in this directory.
- Tests live in `harmony/checks/lib/nixago/`: request normalization, hook
  behavior (sandboxed git repo), a raw-upstream-request compatibility check,
  and golden renders per generator. To refresh a golden after an intentional
  change, build the failing check and copy the rendered file over
  `checks/lib/nixago/_testdata/<name>.golden`.
