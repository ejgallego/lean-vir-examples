import Lake
open Lake DSL

package lean_vir_examples where

require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "000885e3aef1c04e3af91d2261ff4a1feff226e9"

@[default_target]
lean_lib Examples where
  globs := #[.andSubmodules `Examples]
