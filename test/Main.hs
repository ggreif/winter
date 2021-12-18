module Main where

import Data.List
import System.Directory
import System.Environment
import Test.Tasty (defaultMain, testGroup)

import Property as Property (tests)
import Unit as Unit (tests)
import Spec as Spec (tests)

main :: IO ()
main = do
  mwasmPath <- lookupEnv "WASM_SPEC_TESTS"
  testDir <- case mwasmPath of
      Nothing -> error "Please define WASM_SPEC_TESTS to point to .../WebAssembly/spec/test/core"
      Just path -> pure path
  putStrLn $ "Using wasm spec test directory: " ++ testDir
  files <- listDirectory testDir
  let wastFiles = flip concatMap files $ \file ->
        [ testDir ++ "/" ++ file
        | ".wast" `isSuffixOf` file
          && file `notElem`
          [ "inline-module.wast"
            -- We aren't going to bother fully supporting
            -- Unicode function names in the reference interpreter yet.
          , "names.wast"
            -- These contain features that `winter` won't accept yet
          , "bulk.wast"
          , "ref_null.wast"
          , "memory_init.wast"
          , "table_fill.wast"
          , "table_copy.wast"
          , "ref_null.wast"
          , "table_get.wast"
          , "table_grow.wast"
          , "table.wast"
          , "ref_is_null.wast"
          , "ref_func.wast"
          , "imports.wast"
          , "br_table.wast"
          , "table_init.wast"
          , "table_set.wast"
          , "global.wast"
          , "linking.wast"
          , "unreached-valid.wast"
          , ""
          , ""
          ]
        ]

  defaultMain $ testGroup "main"
    [ Property.tests
    , Unit.tests
    , Spec.tests wastFiles
    ]
