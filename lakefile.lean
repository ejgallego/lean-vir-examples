import Lake
open Lake DSL

package lean_vir_examples where

require lean_vir from git
  "https://github.com/ejgallego/lean-vir" @ "8a95e9223b6eb211318eb8d4cc84008ffbfd6e6c"

@[default_target]
lean_lib Examples where
  globs := #[.andSubmodules `Examples]
