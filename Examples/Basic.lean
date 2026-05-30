/-
Copyright (c) 2026 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Emilio J. Gallego Arias
-/

import LeanVir.Browser

namespace Examples.Basic

def total (values : Array Nat) : Nat :=
  values.foldl (fun acc value => acc + value) 0

def greeting (name : String) : String :=
  "Hello, " ++ name

def titleHandshake (title : String) : IO String := do
  Lean.Vir.Browser.Document.setTitle title
  Lean.Vir.Browser.Document.getTitle

end Examples.Basic
