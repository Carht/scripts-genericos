import Data.Char as DC (toLower)
import System.Directory as SD (listDirectory, renamePath)
import System.FilePath ((</>))
import Control.Monad (forM, mapM_)

toLowerPath :: FilePath -> FilePath
toLowerPath = map DC.toLower

fileToLower :: FilePath -> IO [FilePath]
fileToLower path = do
  files <- fullPath path
  return (map toLowerPath files)

fullPath :: FilePath -> IO [FilePath]
fullPath inputPath = do
  files <- SD.listDirectory inputPath
  fullFilePaths <- forM files $ \file -> do
    let fullPath = inputPath </> file
    return fullPath
  return fullFilePaths

changePath :: (FilePath, FilePath) -> IO ()
changePath (oldPath, newPath) = do
  SD.renamePath oldPath newPath

changeFilename :: FilePath -> IO ()
changeFilename [] = putStrLn "No input data"
changeFilename path = do
  files <- fullPath path
  newNames <- fileToLower path
  mapM_ changePath (zip files newNames)
