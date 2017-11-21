import Control.Monad

-- Continue with Monads, List Comprehensions

-- Wrapping around something of some type.

-- Examples:
--  Maybe t -- models "failure"
--  [t] -- models multiple choices
--  IO t -- models an IO action (World->World) yielding a t.

--  (>>=) :: m a -> (a -> m b) -> mb     -- "bind"
--  return :: a -> m a

-- Identity ("Monad Laws")
--    mx >>= return == mx

pyTriples n =
  return () >>= (\_ -> [1..n])
  >>= (\x -> map (\y->(x,y)) [1..n])                -- choices
  >>= (\p@(x,y) -> if x<y then return p else []) -- guard
  >>= (\(x,y) -> map (\z -> (x,y,z)) [1..n])        -- choices
  >>= (\p@(x,y,z) -> if x^2+y^2==z^2 then return p else []) -- guard

pyTriples___ n = do
  return ()
  x <- [1..n]
  y <- [1..n]
  guard (x<y)
  z <- [1..n]
  guard (x^2+y^2==z^2)
  return (x,y,z)

-- Sugar for List Monad (and lists in general)
--   [i..j], [i,j..k]
--   [ expression | clause+ ]
--         where clause is either var<-list  or   boolean expression
--         where expression can use vars in clauses

pyTriples_ n = [(x,y,z) | x<-[1..n], y<-[1..n], x<y, z<-[1..n], x^2+y^2==z^2]
pyTriples__ n = [(x,y,z) | x<-[1..n], y<-[x+1..n], z<-[1..n], x^2+y^2==z^2]

-- what's going on with this:
--       print "foo" ; print "bar"
-- ; denotes sequencing of I/O actions

printFoo = putChar 'f'
  >>= \_ -> putChar 'o'
  >>= \_ -> putChar 'o'
  >>= \_ -> putChar '\n'

-- This     >>= \_ ->    is ;
-- (>>) is predefined:
--    mx >> my = mx >>= \_ -> my

printFoo_ = putChar 'f'
  >> putChar 'o'
  >> putChar 'o'
  >> putChar '\n'

printFoo__ = do
  putChar 'f'
  putChar 'o'
  putChar 'o'
  putChar '\n'

r1cp3 = getChar
  >>= \c ->
        let pc = putChar c
        in (pc >> pc >> pc >> putChar '\n')

r1cp3_ = getChar
  >>= \c -> doNtimes 3 (putChar c) >> putChar '\n'

doNtimes :: Int -> IO () -> IO ()
doNtimes n a = foldl (>>) (return ()) (take n (repeat a))

putString :: [Char] -> IO ()
putString cs = foldl (>>) (return ()) (map putChar cs) >> putChar '\n'

-- Syntactic Sugar for Monads: "do" syntax
