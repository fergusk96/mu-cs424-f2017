-- Haskell!

-- Scheme            vs          Haskell

-- reified                       reified
-- untyped                       typed
-- λ-Calculus                    λ-Calculus

-- small                         large, florescence of features
-- little syntactic sugar        embraces sugar!!!  (to look like math)

-- gazzilion implementations     one major implementation (GHC)

-- snide greybeards (NOT REALLY) friendly math geeks

-- n-ary functions               all functions curried      

-- "not pure"                    pure

-- eager evaluation              lazy evaluation

-- I/O, mutation hacky           I/O, mutation use "Monads"

-- cons                          (:)
-- car                           head
-- cdr                           tail

-- s-expressions                 algebraic datatypes, pattern matching


-- HASKELL

-- infix operators: made of +, *, /, ^, ...
-- regular identifiers: a..z, 0..9, ...  (unless interpretable as number)

-- function call: juxtaposition
-- (+)   -- can use as prefix
-- `div` -- can use as infix

hypot1, hypot2, hypot3 :: Double -> Double -> Double

hypot1 x y = sqrt(x^2 + y^2)
-- sugar for this:   hypot = λ x y . sqrt(x^2 + y^2)    which is written:
hypot2 = \x y -> sqrt(x^2+y^2)
-- sugar for this:
hypot3 = \x -> \y -> sqrt (x^2+y^2)

-- *Main> fromEnum 'a'
-- 97
-- *Main> :t toEnum
-- toEnum :: Enum a => Int -> a
-- *Main> toEnum 98 :: Char
-- 'b'

-- List Syntax:
-- []  empty list
-- x : xs     cons element x to list xs



-- sugar:

-- *Main> 1:(2:(3:[]))
-- [1,2,3]
-- *Main> [1,2,3]
-- [1,2,3]

length_ [] = 0
length_ (_:xs) = 1 + length_ xs

-- *Main> :t length_
-- length_ :: Num t => [t1] -> t
-- *Main> length_ "fjidos"
-- 6
