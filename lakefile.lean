import Lake
open Lake DSL

package lean_vir_examples where

require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "3b9c3785534222f971fb80495cf9d2731b515aae"

@[default_target]
lean_lib Examples where
  globs := #[.andSubmodules `Examples]
