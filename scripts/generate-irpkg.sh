#!/usr/bin/env bash
#
# Copyright (c) 2026 Lean FRO LLC. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Author: Emilio J. Gallego Arias

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p build web/public

lake exe lean_vir/vir_irpkg \
  web/public/basic.irpkg \
  build/basic.report.md \
  --target Examples/Basic.lean \
  Examples.Basic.total \
  Examples.Basic.greeting \
  Examples.Basic.titleHandshake
