/*
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
*/

import { loadVirPackage } from "./vir.js";

const form = document.querySelector("#demo-form");
const valuesInput = document.querySelector("#values");
const nameInput = document.querySelector("#name");
const output = document.querySelector("#output");

const vir = await loadVirPackage("basic");

function parseValues(text) {
  return text
    .replace(/[\[\]]/g, " ")
    .split(/[,\s]+/)
    .filter(Boolean)
    .map((part) => {
      if (!/^\d+$/.test(part)) {
        throw new Error(`invalid Nat literal: ${part}`);
      }
      return Number(part);
    });
}

function run() {
  const values = parseValues(valuesInput.value);
  const name = nameInput.value;
  const total = vir.call("Examples.Basic.total", values);
  const greeting = vir.call("Examples.Basic.greeting", name);
  output.textContent = JSON.stringify({ total, greeting }, null, 2);
}

form.addEventListener("submit", (event) => {
  event.preventDefault();
  try {
    run();
  } catch (error) {
    output.textContent = error.stack ?? String(error);
  }
});

run();
