-- Haskell Three

-- Define our own version of "Maybe"

data Mebe t = Yup t | Nope
  deriving (Show, Eq)

sqrt_ :: Double -> Mebe Double
-- sqrt_ x = if (x<0) then Nope else Yup (sqrt x)
sqrt_ x | x<0 = Nope
sqrt_ x = Yup (sqrt x)

log_ :: Double -> Mebe Double
log_ x | x<=0 = Nope
log_ x = Yup (log x)

	-- Side Note: | means if _ then _ i.e. | y==2 = x=5

(///) :: Double -> Double -> Mebe Double
x /// y | y==0 = Nope
x /// y = Yup (x/y)

head_ :: [a] -> Mebe a
head_ [] = Nope
head_ (x:_) = Yup x

	-- Side Notes: \ == lambda and it declares a variable

composeMebe :: (b -> Mebe c) -> (a -> Mebe b) -> (a -> Mebe c)
composeMebe f g x =
  case (g x) of
    Nope -> Nope
    Yup y -> f y

mebeChain :: Mebe a -> (a -> Mebe b) -> Mebe b
mebeChain Nope _ = Nope
mebeChain (Yup x) f = f x

mebeApply :: Mebe a -> (a -> b) -> Mebe b
mebeApply Nope _ = Nope
mebeApply (Yup x) f = Yup (f x)

-- Already defined in system:
--  Maybe = Mebe
--  Just = Yup
--  Nothing = Nope
--  (>>=), pronounced "bind" = mebeChain
--  fmap = mebeApply

sqrt__ :: Double -> Maybe Double
sqrt__ x | x<0 = Nothing
-- f $ x = f x
sqrt__ x = Just $ sqrt x

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

(+/-) :: Double -> Double -> [Double]
x +/- y = [x-y, x+y]
e.g. 5 +/- 1 = [4.0, 6.0]

chainNDL :: [a] -> (a -> [b]) -> [b]
chainNDL xs f = foldl (++) [] (map f xs)

-- *Main> [5,10] >>= (+/- 2) >>= (+/- 0.1)
-- [2.9,3.1,6.9,7.1,7.9,8.1,11.9,12.1]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- An I/O action can be thought of as a function that take a
-- worldState and returns a worldState along with a value.
-- The type "IO a" represents exactly that.

-- *Main> :t putChar 
-- putChar :: Char -> IO ()
-- *Main> :t getChar
-- getChar :: IO Char
