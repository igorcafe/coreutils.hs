module Coreutils.Common (splitFlagsAndArgs, headMaybe) where

import Data.List (isPrefixOf, nub, partition)

-- TODO: support "--"
splitFlagsAndArgs :: [String] -> ([String], [String])
splitFlagsAndArgs rawArgs = (flags, args)
  where
    -- partition -flags from positional args
    (rawFlags, args) = partition (\a -> "-" `isPrefixOf` a) rawArgs

    -- padronize flags
    flags = nub $ concatMap (\raw -> if isShortFlag raw then splitShortFlags raw else [raw]) rawFlags

    -- transforms "-la" into ["-l", "-a"]
    splitShortFlags raw = concatMap (\c -> ["-" ++ [c]]) (drop 1 raw)

    -- detect if its a short flag like -l, -a, or even combined short flags like -la
    isShortFlag rawArg = rawArg /= "-" && not ("--" `isPrefixOf` rawArg) && "-" `isPrefixOf` rawArg

headMaybe :: [a] -> Maybe a
headMaybe [] = Nothing
headMaybe (x : _) = Just x
