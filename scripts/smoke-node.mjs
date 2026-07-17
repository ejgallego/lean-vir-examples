/*
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
*/

import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { createVirRuntimeFactory, createVirtualDocumentState } from "../.lake/build/vir/sdk/js/vir-runtime-node.js";

const wasmBytes = await readFile(new URL("../.lake/build/vir/sdk/wasm/vir-upstream.wasm", import.meta.url));
const irPackageBytes = await readFile(new URL("../.lake/build/vir/modules/Examples/Basic.irpkg", import.meta.url));
const virtualDocumentState = createVirtualDocumentState({ title: "initial" });
const factory = createVirRuntimeFactory({ wasmBytes, virtualDocumentState });
const vir = await factory.createRuntime({ irPackageBytes });

assert.equal(vir.call("Examples.Basic.total", [2, 3, 5, 8]), "18");
assert.equal(vir.call("Examples.Basic.greeting", "Lean"), "Hello, Lean");
assert.equal(vir.call("Examples.Basic.titleHandshake", "Lean VIR"), "Lean VIR");
assert.equal(virtualDocumentState.title, "Lean VIR");

console.log("lean-vir examples smoke ok");
