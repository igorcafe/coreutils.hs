import Coreutils.Coreutils (runCoreutils)
import Coreutils.Ls (runLs)
import Coreutils.Pwd (runPwd)
import System.Environment (getArgs, getProgName)

main = do
  name <- getProgName
  rawArgs <- getArgs
  runProgram name rawArgs

runProgram :: String -> [String] -> IO ()
runProgram "ls" = runLs
runProgram "pwd" = runPwd
runProgram _ = runCoreutils
