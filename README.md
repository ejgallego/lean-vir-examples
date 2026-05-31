# Lean VIR Examples

This repository is a minimal client of the
[`lean_vir`](https://github.com/ejgallego/lean-vir) Lake package.

The example pins `lean_vir` to a single Git commit:

```lean
require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "8a95e9223b6eb211318eb8d4cc84008ffbfd6e6c"
```

To use it:

```bash
lake update
lake build
scripts/fetch-sdk.sh
scripts/generate-irpkg.sh
node scripts/smoke-node.mjs
(cd web && npm ci && npm run build)
```

[`scripts/fetch-sdk.sh`](scripts/fetch-sdk.sh) reads the pinned `lean_vir`
revision from [lake-manifest.json](lake-manifest.json) and asks
`lean_vir/vir_fetch_sdk` for the matching
[GitHub Actions artifact](https://github.com/ejgallego/lean-vir/actions). The
SDK install fails if the downloaded artifact was built from a different commit.
GitHub requires authentication for Actions artifact downloads, so set
`GITHUB_TOKEN` or run
[`gh auth login`](https://cli.github.com/manual/gh_auth_login) once before using
this path locally.

For local development next to the `lean-vir` checkout, build a local SDK
archive and pass it explicitly:

```bash
(cd ../vir && npm run build:sdk-artifact)
scripts/fetch-sdk.sh ../vir/build/artifacts/lean-vir-sdk.tar.gz
```

The example imports the Lake-facing module path from
[Examples/Basic.lean](Examples/Basic.lean):

```lean
import LeanVir.Browser
```

The declarations still live in the public `Lean.Vir.*` namespace, for example
`Lean.Vir.Browser.Document.setTitle`.
