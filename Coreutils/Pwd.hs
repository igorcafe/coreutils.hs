module Coreutils.Pwd (runPwd) where

import Control.Monad (when)
import Coreutils.Common (splitFlagsAndArgs)
import System.Directory (getCurrentDirectory)
import System.Exit (exitFailure)
import System.IO (stderr)
import Text.Printf (hPrintf, printf)

runPwd :: [String] -> IO ()
runPwd rawArgs = do
  let (flags, args) = splitFlagsAndArgs rawArgs
  when (length rawArgs > 0) $ do
    hPrintf stderr "pwd: too many arguments\n"
    exitFailure

  dir <- getCurrentDirectory
  printf "%s\n" dir
