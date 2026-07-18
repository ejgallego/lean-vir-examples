#!/usr/bin/env bash
#
# Copyright (c) 2026 Lean FRO LLC. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Author: Emilio J. Gallego Arias

set -euo pipefail

cd "$(dirname "$0")/.."

lean_vir_commit="${VIR_SDK_COMMIT:-$(
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
)}"

VIR_SDK_COMMIT="$lean_vir_commit" lake build \
  +Examples.Basic:vir \
  +Examples.Slides:vir \
  :virSdk

mkdir -p \
  web/public/vir/modules \
  web/public/vir/sdk/wasm \
  web/src/generated/vir-sdk/js
cp .lake/build/vir/modules/Examples/Basic.irpkg web/public/vir/modules/basic.irpkg
cp .lake/build/vir/modules/Examples/Slides.irpkg web/public/vir/modules/slides.irpkg
cp -R .lake/build/vir/sdk/wasm/. web/public/vir/sdk/wasm
cp -R .lake/build/vir/sdk/js/. web/src/generated/vir-sdk/js
