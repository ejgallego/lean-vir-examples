import Lake
open Lake DSL

package lean_vir_examples where

require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "f76efcc3467b3a64c67460b2e3478441b73f30c2"

@[default_target]
lean_lib Examples where
  globs := #[.andSubmodules `Examples]
