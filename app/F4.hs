module Main where

f4 :: [String] -> String
f4 xs = fSub4 xs "$"

fSub4 :: [String] -> ShowS
fSub4 []     = ('[':) . (']':)
fSub4 (x:xs) = ('[':) . ('@':) . (x++) . fRest4 xs
  where
    fRest4 []     = (']':)
    fRest4 (y:ys) = (',':) . ('@':) . (y++) . fRest4 ys

main :: IO ()
main = mapM_ print 
  [ f4 ([] :: [String]) == "[]$"
  , f4 ["0"] == "[@0]$"
  , f4 ["1","2","3"] == "[@1,@2,@3]$"
  ]