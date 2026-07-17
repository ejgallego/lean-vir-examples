/*
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
*/

import { createVirRuntime } from "./generated/vir-sdk/js/vir-runtime.js";

export function loadVirPackage(name) {
  return createVirRuntime({
    wasmUrl: "/vir/sdk/wasm/vir-upstream.wasm",
    irPackageUrl: `/vir/modules/${name}.irpkg`,
  });
}
