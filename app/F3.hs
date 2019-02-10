module Main where

f3 :: [String] -> String
f3 xs = fSub3 (\x -> '@' : x) xs "$"

fSub3 :: (a -> String) -> [a] -> String -> String
fSub3 _ []     s = "[]" ++ s
fSub3 f (x:xs) s = '[' : f x ++ fRest3 xs
  where
    fRest3 []     = ']' : s
    fRest3 (y:ys) = ',' : f y ++ fRest3 ys

main :: IO ()
main = mapM_ print 
  [ f3 ([] :: [String]) == "[]$"
  , f3 ["0"] == "[@0]$"
  , f3 ["1","2","3"] == "[@1,@2,@3]$"
  ]