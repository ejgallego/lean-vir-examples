#!/usr/bin/env bash
#
# Copyright (c) 2026 Lean FRO LLC. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Author: Emilio J. Gallego Arias

set -euo pipefail

cd "$(dirname "$0")/.."

lean_vir_commit="$(
  node -e '
    const fs = require("node:fs");
    const manifest = JSON.parse(fs.readFileSync("lake-manifest.json", "utf8"));
    const dep = manifest.packages.find((pkg) => pkg.name === "lean_vir");
    if (!dep || !dep.rev) {
      console.error("lean_vir dependency revision not found in lake-manifest.json");
      process.exit(1);
    }
    console.log(dep.rev);
  '
)"

if [[ $# -gt 0 ]]; then
  lake exe lean_vir/vir_fetch_sdk \
    --archive "$1" \
    --expect-commit "$lean_vir_commit" \
    --out web/public/vendor/lean-vir
else
  lake exe lean_vir/vir_fetch_sdk \
    --commit "$lean_vir_commit" \
    --repo ejgallego/lean-vir \
    --out web/public/vendor/lean-vir
fi
