module Coreutils.Ls (runLs) where

import Control.Monad (forM_, unless)
import Coreutils.Common (splitFlagsAndArgs)
import Data.Bits ((.&.))
import Data.Either (partitionEithers)
import Data.List (isPrefixOf, sort)
import System.Directory (listDirectory)
import System.Exit (exitFailure)
import System.IO (stderr)
import System.Posix (FileStatus, directoryMode, fileGroup, fileMode, fileOwner, getFileStatus, getGroupEntryForID, getUserEntryForID, groupExecuteMode, groupName, groupReadMode, groupWriteMode, otherExecuteMode, otherReadMode, otherWriteMode, ownerExecuteMode, ownerReadMode, ownerWriteMode, userName)
import Text.Printf (hPrintf, printf)

runLs :: [String] -> IO ()
runLs rawArgs = do
  let (eitherFlags, args) = parseArgs rawArgs
  let (errors, flags) = partitionEithers eitherFlags
  unless (null errors) $ do
    mapM_ (\e -> hPrintf stderr "ls: %s\n" e) errors
    exitFailure

  files <- listDirectory "."
  let filtered = filterFiles flags args (files ++ [".", ".."])

  let (errors, files) = partitionEithers filtered

  forM_ files $ \file -> do
    if shouldFormatLong flags
      then do
        status <- getFileStatus file
        user <- getUserEntryForID $ fileOwner status
        group <- getGroupEntryForID $ fileGroup status
        putStrLn $ formatLong status user group file
      else do
        putStrLn file

  unless (null errors) $ do
    mapM_ (\e -> hPrintf stderr "ls: %s\n" e) errors
    exitFailure

validFlags = ["-a", "-l"]

validateFlag flag
  | flag `elem` validFlags = Right flag
  | otherwise = Left ("invalid option -- " ++ (dropWhile (== '-') flag))

parseArgs :: [String] -> ([Either String String], [String])
parseArgs rawArgs = (eitherFlags, args)
  where
    (flags, args) = splitFlagsAndArgs rawArgs
    eitherFlags = map validateFlag flags

filterFiles :: [String] -> [String] -> [String] -> [Either String String]
filterFiles flags args files = filtered
  where
    filtered =
      if (null args)
        then
          (sort . (map Right . filter showHidden)) files
        else
          (sort . map matchName) args

    showHidden f = not ("." `isPrefixOf` f) || "-a" `elem` flags

    matchName arg =
      if arg `elem` files
        then Right arg
        else Left ("can't find file " ++ arg)

shouldFormatLong flags = "-l" `elem` flags

formatLong status owner group file = formatted
  where
    mode = fileMode status
    modeStr flag on = if (mode .&. flag) /= 0 then on else "-"

    flags =
      [ (directoryMode, "d"),
        (ownerReadMode, "r"),
        (ownerWriteMode, "w"),
        (ownerExecuteMode, "x"),
        (groupReadMode, "r"),
        (groupWriteMode, "w"),
        (groupExecuteMode, "x"),
        (otherReadMode, "r"),
        (otherWriteMode, "w"),
        (otherExecuteMode, "x")
      ]
    formatFlags flags = concatMap (\t -> (modeStr (fst t) (snd t))) flags
    formatted = printf "%s %s %s %s" (formatFlags flags) (userName owner) (groupName group) file
