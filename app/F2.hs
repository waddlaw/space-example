module Main where

f2 :: [String] -> String
f2 xs = fSub2 (\x s -> '@' : x ++ s) xs "$"

fSub2 :: (a -> ShowS) ->  [a] -> ShowS
fSub2 _ []     s = "[]" ++ s
fSub2 f (x:xs) s = '[' : f x (fRest2 xs)
  where
    fRest2 []     = ']' : s
    fRest2 (y:ys) = ',' : f y (fRest2 ys)

main :: IO ()
main = mapM_ print 
  [ f2 ([] :: [String]) == "[]$"
  , f2 ["0"] == "[@0]$"
  , f2 ["1","2","3"] == "[@1,@2,@3]$"
  ]