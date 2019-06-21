module Data.Semigroup.Means (
    -- * Arithmetic mean
      AM , amWeight , amSum , am , am' , getAM

    -- * Geometric mean
    , GM , gmWeight , gmProduct , gm , getGM

    -- * Harmonic mean
    , HM , hmWeight , hmSum , hm , getHM

    -- * Harmonic mean with zero-value correction
    , HMZ , hmzWeight , hmzSum , hmz , getHMZ

    -- * Quadratic mean
    , QM , qmWeight , qmSum , qm , getQM

    -- * Cubic mean
    , CM , cmWeight , cmSum , cm , getCM

    -- * Midrange mean
    , MM , mmMin , mmMax , mm , getMM

    ) where

import           Data.Semigroup

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Arithmetic mean/
data AM a = AM {
        amWeight :: {-# UNPACK #-} !Int
    ,   amSum    :: a
    } deriving (Show, Eq)

-- | 'AM' with weight 1.
am :: Num a => a -> AM a
am = AM 1
{-# INLINABLE am #-}

-- | 'AM' with weight(weight is 'Int' with 1 as unit).
am' :: Num a => Int -> a -> AM a
am' w v = AM w (fromIntegral w * v)
{-# INLINABLE am' #-}

instance Num a => Semigroup (AM a) where
    AM c1 s1 <> AM c2 s2 = AM (c1 + c2) (s1 + s2)
    {-# INLINE (<>) #-}

getAM :: Fractional a => AM a -> a
getAM (AM c s) = s / fromIntegral c
{-# INLINABLE getAM #-}

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Geometric mean/
data GM a = GM {
        gmWeight  :: {-# UNPACK #-} !Int
    ,   gmProduct :: a
    } deriving (Show, Eq)

gm :: Num a => a -> GM a
gm = GM 1
{-# INLINABLE gm #-}

instance Num a => Semigroup (GM a) where
    GM c1 s1 <> GM c2 s2 = GM (c1 + c2) (s1 * s2)
    {-# INLINE (<>) #-}

getGM :: Floating a => GM a -> a
getGM (GM c p) = p ** (1 / fromIntegral c)
{-# INLINABLE getGM #-}

--------------------------------------------------------------------------------

-- | semigroup for accumulating /Harmonic mean with zero-value correction/
data HMZ a = HMZC {
        hmzWeight :: {-# UNPACK #-} !Int
    ,   hmzZeros  :: {-# UNPACK #-} !Int
    ,   hmzSum    :: a
    }
           | HMZero {
        hmzZeros  :: {-# UNPACK #-} !Int
    }
    deriving (Show, Eq)

instance Num a => Semigroup (HMZ a) where
  HMZero  z1    <> HMZero  z2    = HMZero (z1 + z2)
  HMZC c1 z1 s1 <> HMZero  z2    = HMZC c1 (z1 + z2) s1
  HMZero  z1    <> HMZC c2 z2 s2 = HMZC c2 (z1 + z2) s2
  HMZC c1 z1 s1 <> HMZC c2 z2 s2 = HMZC (c1 + c2) (z1 + z2) (s1 + s2)
  {-# INLINE (<>) #-}

hmz :: (Eq a, Fractional a) => a -> HMZ a
hmz 0.0 = HMZero 1
hmz x   = HMZC 1 0 (1 / x)
{-# INLINABLE hmz #-}

getHMZ :: Fractional a => HMZ a -> a
getHMZ (HMZero _) = 0.0
getHMZ (HMZC c z s) = (fromIntegral c / fromIntegral (c+z)) * (fromIntegral c / s)
{-# INLINABLE getHMZ #-}

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Harmonic mean/
data HM a = HM {
        hmWeight :: {-# UNPACK #-} !Int
    ,   hmSum    :: a
    } deriving (Show, Eq)

hm :: Fractional a => a -> HM a
hm x = HM 1 (1 / x)
{-# INLINABLE hm #-}

instance Num a => Semigroup (HM a) where
    HM c1 s1 <> HM c2 s2 = HM (c1 + c2) (s1 + s2)
    {-# INLINE (<>) #-}

getHM :: Fractional a => HM a -> a
getHM (HM c s) = fromIntegral c / s
{-# INLINABLE getHM #-}

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Quadratic mean/
data QM a = QM {
        qmWeight :: {-# UNPACK #-} !Int
    ,   qmSum    :: a
    } deriving (Show, Eq)

qm :: Fractional a => a -> QM a
qm x = QM 1 (x ^ (2 :: Int))
{-# INLINABLE qm #-}

instance Num a => Semigroup (QM a) where
    QM c1 s1 <> QM c2 s2 = QM (c1 + c2) (s1 + s2)
    {-# INLINE (<>) #-}

getQM :: Floating a => QM a -> a
getQM (QM c s) = sqrt (s / fromIntegral c)
{-# INLINABLE getQM #-}

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Cubic mean/
data CM a = CM {
        cmWeight :: {-# UNPACK #-} !Int
    ,   cmSum    :: a
    } deriving (Show, Eq)

cm :: Fractional a => a -> CM a
cm x = CM 1 (x ^ (3 :: Int))
{-# INLINABLE cm #-}

instance Num a => Semigroup (CM a) where
    CM c1 s1 <> CM c2 s2 = CM (c1 + c2) (s1 + s2)
    {-# INLINE (<>) #-}

getCM :: Floating a => CM a -> a
getCM (CM c s) = (s / fromIntegral c) ** (1/3)
{-# INLINABLE getCM #-}

--------------------------------------------------------------------------------

-- | semigroup for accumalting /Midrange mean/
data MM a = MM {
        mmMin :: a
    ,   mmMax :: a
    } deriving (Show, Eq)

mm :: a -> MM a
mm x = MM x x
{-# INLINABLE mm #-}

instance Ord a => Semigroup (MM a) where
    MM min1 max1 <> MM min2 max2 =
        let min' = min min1 min2
            max' = max max1 max2
        in MM min' max'
    {-# INLINE (<>) #-}

getMM :: Fractional a => MM a -> a
getMM (MM min' max') = (max' + min') / 2
{-# INLINABLE getMM #-}

--------------------------------------------------------------------------------
