# Lean VIR Examples

This repository is a small client of the
[`lean_vir`](https://github.com/ejgallego/lean-vir) Lake package. It demonstrates
both supported browser entrypoint styles:

- `@[vir_export]` exposes Lean functions for explicit JavaScript calls.
- `@[vir_startup]` exposes a zero-argument hook that JavaScript runs after
  loading its VIR package.

The dependency is pinned to an exact commit in [`lakefile.lean`](lakefile.lean).

## Build and test

```bash
lake update
lake build
scripts/prepare-web.sh
node scripts/smoke-node.mjs
(cd web && npm ci && npm run build)
```

`scripts/prepare-web.sh` performs the user-facing integration workflow. It
builds `+Examples.Basic:vir` and `+Examples.Slides:vir`, installs the matching
SDK through `:virSdk`, and stages those generated artifacts for the web app.
Vite bundles the SDK JavaScript from its generated source directory and serves
the Wasm and `.irpkg` files as public assets. For an unreleased dependency, the
script derives the exact SDK commit from `lake-manifest.json`. GitHub artifact
downloads require `GITHUB_TOKEN` or an authenticated
[`gh`](https://cli.github.com/manual/gh_auth_login) session.

For local development next to a `lean-vir` checkout, provide its SDK archive
without waiting for GitHub Actions:

```bash
(cd ../lean-vir && npm run build:sdk-artifact)
VIR_SDK_ARCHIVE=../lean-vir/build/artifacts/lean-vir-sdk.tar.gz scripts/prepare-web.sh
```

## Run in the browser

```bash
(cd web && npm run dev)
```

Then open:

- <http://127.0.0.1:5173/> for explicit calls into
  [`Examples/Basic.lean`](Examples/Basic.lean).
- <http://127.0.0.1:5173/slides.html> for the startup hook in
  [`Examples/Slides.lean`](Examples/Slides.lean). Lean creates the slide's
  vertical source/result split, copy, status, accessible canvas, and
  time-based bouncing animation; JavaScript only loads the package and calls
  `vir.runStartupEntries()`.

## Lean entrypoints

Import `Vir` and mark only the declarations that form the browser surface:

```lean
import Vir

@[vir_export]
def Examples.Basic.greeting (name : String) : String :=
  "Hello, " ++ name

@[vir_startup]
def Examples.Slides.mount : Lean.Vir.Browser.DomM Unit := do
  -- Create and mount the slide through the typed browser API.
  pure ()
```

Build either module directly with its Lake facet:

```bash
lake build +Examples.Basic:vir
lake build +Examples.Slides:vir
```
