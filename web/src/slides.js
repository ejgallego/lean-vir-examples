/*
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
*/

import { loadVirPackage } from "./vir.js";

const runtimeStatus = document.querySelector("#runtime-status");

try {
  const vir = await loadVirPackage("slides");
  vir.runStartupEntries();
  runtimeStatus.textContent = "The startup hook is running from compiled Lean.";
  window.addEventListener("pagehide", () => vir.dispose(), { once: true });
} catch (error) {
  runtimeStatus.textContent = error.stack ?? String(error);
  runtimeStatus.classList.add("runtime-error");
}
