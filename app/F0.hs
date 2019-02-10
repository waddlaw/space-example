module Main where

f0 :: [String] -> String
f0 xs = fSub0 (\x -> '@' : x) xs "$"

fSub0 :: (a -> String) -> [a] -> String -> String
fSub0 _ []     s = "[]" ++ s
fSub0 f (x:xs) s = '[' : f x ++ fRest0 xs ++ s
  where
    fRest0 []     = "]"
    fRest0 (y:ys) = ',' : f y ++ fRest0 ys

main :: IO ()
main = mapM_ print 
  [ f0 ([] :: [String]) == "[]$"
  , f0 ["0"] == "[@0]$"
  , f0 ["1","2","3"] == "[@1,@2,@3]$"
  ]

{-
  f0 ["1","2","3"]
= fSub0 (\x -> '@' : x) ["1","2","3"] "$"
= '[' : (\x -> '@' : x) "1" ++ fRest0 ["2", "3"] ++ "$" 
-}

{-
  fRest0 ["2", "3"] ++ "$"
= (',' : (\x -> '@' : x) "2" ++ fRest0 ["3"]) ++ "$"
= (',' : (\x -> '@' : x) "2" ++ (',' :)) ++ "$"
-}