-- Objects
--  Typeclasses in Haskell
--  duck typed objects in Scheme
--  subtypes in typed λ Calculus

-- Fields should obay some identities, such as:
--  a `mul` (b `add` c) = (a `mul` b) `add` (a `mul` d)
--  add and mul are associative
--  add is commutative
--  one is identity element of mul
--  zero is identity element of add
--  zero is zero element of mul

class Field a where
  add :: a -> a -> a
  mul :: a -> a -> a
  zero :: a
  one :: a

-- Complex number, represented in rectangular coords
data Rect = Rect Double Double -- real, imaginary parts
  deriving (Eq, Show)

-- Complex number in rect coords forms a field:
instance Field Rect where
  add (Rect x y) (Rect x' y') = Rect (x+x') (y+y')
  mul (Rect x y) (Rect x' y') = Rect (x*x' - y*y') (x*y' + x'*y)
  zero = Rect 0 0
  one = Rect 1 0

-- in Polar Coordinates
data Polar = Polar Double Double -- magnitude & phase
  deriving (Eq, Show)

-- Complex number in Polar coords forms a field:
instance Field Polar where
  add a b = rectToPolar $ (polarToRect a) `add` (polarToRect b)
  mul (Polar mag phase) (Polar mag' phase')
    = Polar (mag*mag') (piLimit (phase+phase'))
  zero = Polar 0 0
  one = Polar 1 0

piLimit a | a <= -pi = piLimit (a+pi)
piLimit a | a >   pi = piLimit (a-pi)
piLimit a = a

polarToRect :: Polar -> Rect
polarToRect (Polar mag phase) = Rect (mag*cos phase) (mag*sin phase)
rectToPolar :: Rect -> Polar
rectToPolar (Rect x y) = Polar (hypot x y) (atan2 y x)

hypot x y = sqrt (x^2 + y^2)
-- TERRIBLE CODE!!!
-- *Main> hypot (3e300) (4e300)
-- Infinity
-- *Main> hypot (3e-300) (4e-300)
-- 0.0
-- Should take max(abs(x),abs(y)) out of sqrt.

-- *Main Data.Complex> fromInteger (17::Integer)   -- When I type 17 in Haskell

data ComplexPolarRect = CRect Double Double | CPolar Double Double
  deriving Show

instance Field ComplexPolarRect where
  add z z' = CRect (rePart z + rePart z') (imPart z + imPart z')
  mul (CRect x y) (CRect x' y') = CRect (x*x' - y*y') (x*y' + x'*y)
  mul (CPolar mag phase) (CPolar mag' phase')
    = CPolar (mag*mag') (piLimit (phase+phase'))
  mul z z' = CRect (x*x' - y*y') (x*y' + x'*y)
    where x = rePart z
          y = imPart z
          x' = rePart z'
          y' = imPart z'
  zero = CRect 0 0
  one = CRect 1 0

rePart, imPart :: ComplexPolarRect -> Double
rePart (CRect x _) = x
rePart (CPolar mag phase) = mag * cos phase
imPart (CRect _ y) = y
imPart (CPolar mag phase) = mag * sin phase

instance Eq ComplexPolarRect where
  CPolar mag phase == CPolar mag' phase' = mag==mag' && phase==phase'
  z == z' = rePart z == rePart z' && imPart z == imPart z'
