import Control.Monad (when)
import Coreutils.Common (splitFlagsAndArgs)
import Coreutils.Coreutils (runCoreutils)
import Coreutils.Ls (runLs)
import System.Environment (getArgs, getProgName)
import System.Exit (exitFailure)
import System.IO (stderr)
import Text.Printf (hPrintf)

main = do
  name <- getProgName
  rawArgs <- getArgs
  runProgram name rawArgs

runProgram :: String -> [String] -> IO ()
runProgram "ls" = runLs
runProgram _ = runCoreutils
