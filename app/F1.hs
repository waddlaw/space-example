module Main where

f1 :: [String] -> String
f1 xs = fSub1 (\x -> '@' : x) xs "$"

fSub1 :: (a -> String) -> [a] -> String -> String
fSub1 _ []     s = "[]" ++ s
fSub1 f (x:xs) s = '[' : f x ++ fRest1 xs s
  where
    fRest1 []     s = ']' : s
    fRest1 (y:ys) s = ',' : f y ++ fRest1 ys s

main :: IO ()
main = mapM_ print 
  [ f1 ([] :: [String]) == "[]$"
  , f1 ["0"] == "[@0]$"
  , f1 ["1","2","3"] == "[@1,@2,@3]$"
  ]