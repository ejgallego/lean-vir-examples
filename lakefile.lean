import Lake
open Lake DSL

package lean_vir_examples where

require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "a5947808e93b232dc886ded466b211de81f4b023"

@[default_target]
lean_lib Examples where
  globs := #[.andSubmodules `Examples]
