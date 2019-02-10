# space-example

`last (f (replicate 10000000 "1"))` の結果。

最終結果 | f0 | f1 | f2 | f3 | f4
--------|----|----|----|-----|-----
time (sec) | 5.38 | 6.69 | 5.41 | 5.41 | 11.59
(optimized) time (sec) | 0.81 | 0.56 | 0.56 | 0.55 | 0.54
space (Mbyte) | 6,400 | 4,960 | 4,160 | 4,720 | 7,600
(optimized) space (Mbyte) | 4,640 | 3,120 | 2,720 | 2,960 | 2,320

## ベンチマーク

stack repl

```haskell
ghci> :set :s

ghci> main0
(0.00 secs, 443,480 bytes)

ghci> main1
(0.00 secs, 442,904 bytes)

ghci> main2
(0.00 secs, 442,600 bytes)

ghci> main3
(0.01 secs, 442,824 bytes)
```

ghci

```haskell
ghci> main0
(0.01 secs, 87,832 bytes)

ghci> main1
(0.00 secs, 87,256 bytes)

ghci> main2
(0.00 secs, 86,952 bytes)

ghci> main3
(0.01 secs, 87,176 bytes)

ghci> main4
(0.01 secs, 87,912 bytes)
```

### f (replicate 10000 "1")

```haskell
ghci> f0 (replicate 10000 "1")
(4.29 secs, 29,592,288 bytes)

ghci> f1 (replicate 10000 "1")
(4.96 secs, 28,168,616 bytes)

ghci> f2 (replicate 10000 "1")
(3.35 secs, 27,348,528 bytes)

ghci> f3 (replicate 10000 "1")
(3.69 secs, 27,911,040 bytes)

ghci> f4 (replicate 10000 "1")
(3.04 secs, 30,773,440 bytes)
```

### f (replicate 30000 "1")

```haskell
ghci> f0 (replicate 30000 "1")


ghci> f1 (replicate 30000 "1")


ghci> f2 (replicate 30000 "1")
(10.22 secs, 81,885,432 bytes)

ghci> f3 (replicate 30000 "1")


ghci> f4 (replicate 30000 "1")
(13.28 secs, 92,245,608 bytes)
```

### last (f (replicate 10000000 "1"))

```haskell
ghci> last (f0 (replicate 10000000 "1"))
(5.38 secs, 6,400,073,552 bytes)

ghci> last (f1 (replicate 10000000 "1"))
(6.69 secs, 4,960,073,552 bytes)

ghci> last (f2 (replicate 10000000 "1"))
(5.41 secs, 4,160,073,560 bytes)

ghci> last (f3 (replicate 10000000 "1"))
(5.41 secs, 4,720,073,560 bytes)

ghci> last (f4 (replicate 10000000 "1"))
(11.59 secs, 7,600,073,544 bytes)
```

`ghci app/F4.hs -fobject-code -O2` でも試した。

```haskell
ghci> last (f0 (replicate 10000000 "1"))
(0.81 secs, 4,640,085,352 bytes)

ghci> last (f1 (replicate 10000000 "1"))
(0.56 secs, 3,120,085,368 bytes)

ghci> last (f2 (replicate 10000000 "1"))
(0.56 secs, 2,720,085,392 bytes)

ghci> last (f3 (replicate 10000000 "1"))
(0.55 secs, 2,960,085,392 bytes)

ghci> last (f4 (replicate 10000000 "1"))
(0.54 secs, 2,320,085,360 bytes)
```

## -ddump-simpl

```shell
λ cabal new-build f0 --ghc-options=-ddump-simpl > f0-core-simpl.log
```

見やすく手で整形してあります。

### F0

#### f0

```haskell
f0 :: [String] -> String
f0 = \xs -> fSub0 Main.f3 xs Main.f1

Main.f1 :: [Char]
Main.f1 = unpackCString# Main.f2

Main.f2 :: Addr#
Main.f2 = "$"#

Main.f3 :: [Char] -> [Char]
Main.f3 = \x -> (:) Main.f4 x

Main.f4 :: Char
Main.f4 = C# '@'#
```

#### fsub0

```haskell
Main.fSub4 :: Char
Main.fSub4 = C# '['#

Main.fSub3 :: Addr#
Main.fSub3 = "]"#

Main.fSub2 :: [Char]
Main.fSub2 = unpackCString# Main.fSub3

Main.fSub1 :: Char
Main.fSub1 = C# ','#

Main.fSub5 :: Addr#
Main.fSub5 = "[]"#

fSub0 :: forall a. (a -> String) -> [a] -> String -> String
fSub0 = \f x_xs s ->
  case x_xs of {
    [] -> unpackAppendCString# Main.fSub5 s;
    (x:xs) -> Main.fSub4 :
        (++ (f x)
            (letrec {
              fRest0 = \y_ys ->
                case y_ys of {
                  [] -> Main.fSub2;
                  (y:ys) -> : Main.fSub1 (++ (f y) (fRest0 ys))
                }; } in
            ++ (fRest0 xs) s)
        )
  }
```

### F1

#### f1

```haskell
Main.f5 :: Char
Main.f5 = C# '@'#

Main.f4 :: [Char] -> [Char]
Main.f4 = \x -> : Main.f5 x

Main.f3 :: Addr#
Main.f3 = "$"#

Main.f2 :: [Char]
Main.f2 = unpackCString# Main.f3

f1 :: [String] -> String
f1 = \xs -> fSub1 Main.f4 xs Main.f2
```

#### fSub1

```haskell
Main.fSub4 :: Char
Main.fSub4 = C# '['#

Main.fSub3 :: Char
Main.fSub3 = C# ']'#

Main.fSub2 :: Char
Main.fSub2 = C# ','#

Main.fSub5 :: Addr#
Main.fSub5 = "[]"#
```

## プロファイル結果

```shell
λ stack run f0 --profile -- +RTS -s
```

### F0

```shell
          66,792 bytes allocated in the heap
           5,176 bytes copied during GC
          46,352 bytes maximum residency (1 sample(s))
          23,280 bytes maximum slop
               0 MB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0         0 colls,     0 par    0.000s   0.000s     0.0000s    0.0000s
  Gen  1         1 colls,     0 par    0.000s   0.001s     0.0011s    0.0011s

  INIT    time    0.000s  (  0.003s elapsed)
  MUT     time    0.000s  (  0.001s elapsed)
  GC      time    0.000s  (  0.001s elapsed)
  RP      time    0.000s  (  0.000s elapsed)
  PROF    time    0.000s  (  0.000s elapsed)
  EXIT    time    0.000s  (  0.001s elapsed)
  Total   time    0.001s  (  0.007s elapsed)

  %GC     time       0.0%  (0.0% elapsed)

  Alloc rate    242,880,000 bytes per MUT second

  Productivity  28.9% of total user, 19.2% of total elapsed
```

### F1

```
          66,016 bytes allocated in the heap
           5,176 bytes copied during GC
          46,352 bytes maximum residency (1 sample(s))
          23,280 bytes maximum slop
               0 MB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0         0 colls,     0 par    0.000s   0.000s     0.0000s    0.0000s
  Gen  1         1 colls,     0 par    0.000s   0.001s     0.0008s    0.0008s

  INIT    time    0.000s  (  0.003s elapsed)
  MUT     time    0.000s  (  0.001s elapsed)
  GC      time    0.000s  (  0.001s elapsed)
  RP      time    0.000s  (  0.000s elapsed)
  PROF    time    0.000s  (  0.000s elapsed)
  EXIT    time    0.000s  (  0.000s elapsed)
  Total   time    0.001s  (  0.006s elapsed)

  %GC     time       0.0%  (0.0% elapsed)

  Alloc rate    243,601,476 bytes per MUT second

  Productivity  29.8% of total user, 22.5% of total elapsed
```

### F2

```
          65,808 bytes allocated in the heap
           5,176 bytes copied during GC
          46,352 bytes maximum residency (1 sample(s))
          23,280 bytes maximum slop
               0 MB total memory in use (0 MB lost due to fragmentation)

                                     Tot time (elapsed)  Avg pause  Max pause
  Gen  0         0 colls,     0 par    0.000s   0.000s     0.0000s    0.0000s
  Gen  1         1 colls,     0 par    0.000s   0.001s     0.0009s    0.0009s

  INIT    time    0.000s  (  0.004s elapsed)
  MUT     time    0.000s  (  0.001s elapsed)
  GC      time    0.000s  (  0.001s elapsed)
  RP      time    0.000s  (  0.000s elapsed)
  PROF    time    0.000s  (  0.000s elapsed)
  EXIT    time    0.000s  (  0.000s elapsed)
  Total   time    0.001s  (  0.006s elapsed)

  %GC     time       0.0%  (0.0% elapsed)

  Alloc rate    237,574,007 bytes per MUT second

  Productivity  27.9% of total user, 21.0% of total elapsed
```