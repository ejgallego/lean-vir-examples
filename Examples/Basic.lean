/-
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
-/

import Vir

namespace Examples.Basic

@[vir_export]
def total (values : Array Nat) : Nat :=
  values.foldl (fun acc value => acc + value) 0

@[vir_export]
def greeting (name : String) : String :=
  "Hello, " ++ name

@[vir_export]
def titleHandshake (title : String) : Lean.Vir.Browser.DomM String := do
  Lean.Vir.Browser.Document.setTitle title
  Lean.Vir.Browser.Document.getTitle

end Examples.Basic
