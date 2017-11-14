-- Haskell 2

-- fib

-- Not very idiomatic Haskell (Scheme-like definition)
fib1 n =
  if n==0 then 1
  else if n==1 then 1
  else fib1 (n-1) + fib1 (n-2)

-- A bit more idiomatic
fib2 0 = 1
fib2 1 = 1
fib2 n = fib2 (n-1) + fib2 (n-2)

-- De-sugared fib2
fib3 n =
  case n of
    0 -> 1
    1 -> 1
    n -> fib3 (n-1) + fib3 (n-2)

-- Use tail recursion to reduce complexity from O(2^n) to O(n).
-- (Scheme-style)
fib4 0 = 1
fib4 n =
  let
    -- aux returns fib n, assuming:
    --   i <= n
    --   fi = fib i
    --   fim1 = fib (i-1)
    aux i fi fim1 = if i==n then fi else aux (i+1) (fi+fim1) fi
  in
    aux 1 1 1

-- Sugar: "where" construct
fib5 0 = 1
fib5 n = aux 1 1 1
  where
    aux i fi fim1 = if i==n then fi else aux (i+1) (fi+fim1) fi

fib6 n = fibs !! n

fibs :: [Integer]
{-
fibs = [1,1,2,3,5,8,13,...]

     [1,1,2,3,5,  8,13,...]   = fibs
   + [1,2,3,5,8, 13,...]     = tail fibs
   --------------------
     [2,3,5,8,13,21,...]

  so   zipWith (+) fibs (tail fibs)    = drop 2 fibs
-}
fibs = 1:1:zipWith (+) fibs (tail fibs)

{-
Algebraic Identity of take & drop on lists:
for any list xs,
    any non-negative Int i,
    take i xs ++ drop i xs == xs
-}

{-
-- Idiomatic Haskell:
*Main> take 10 (iterate sqrt (2^32))
[4.294967296e9,65536.0,256.0,16.0,4.0,2.0,1.4142135623730951,1.189207115002721,1.0905077326652577,1.0442737824274138]
*Main> iterate sqrt (2^32) !! 7
1.189207115002721
-}

-- Algebraic Datatypes
--   - simple idea
--   - unifies: stuct, union, enum
--   - pleasant to type

-- Algebraic Datatype, like a C enum
data Color = Red | Blue | Green | Yellow
  deriving (Show, Eq)

isRed Red = True
isRed _ = False

-- Algebraic Datatype, like a C struct
data Pixel = Pixel Int Int Int
  deriving (Show, Eq)
