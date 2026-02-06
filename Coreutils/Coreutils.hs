module Coreutils.Coreutils (runCoreutils) where

import Control.Monad (when)
import Coreutils.Common (splitFlagsAndArgs)
import System.Exit (exitFailure)
import System.IO (stderr)
import Text.Printf (hPrintf)

runCoreutils rawArgs = do
  let (flags, args) = splitFlagsAndArgs rawArgs

  when ("--help" `elem` flags) $ do
    hPrintf stderr "coreutils: i don't want to help you\n"
    exitFailure

  hPrintf stderr "try 'coreutils --help' for more options\n"
  exitFailure

runProgram name _ = do
  hPrintf stderr "%s: unknown program '%s'\n" name name
  exitFailure
