module Primes
    ( primesBelow
    )
where

primeFactors :: Integer -> [Integer]
primeFactors n = filter (\p -> n `mod` p == 0) $ primesBelow n

-- | List of all primes below a given limit.
--
-- Computed with the Sieve of Eratosthenes.
--
-- > primesBelow 10
-- [2,3,5,7]
primesBelow :: Integer -> [Integer]
primesBelow lim = multipleFilter' [2..lim] []
    where multipleFilter' :: [Integer] -> [Integer] -> [Integer]
          --multipleFilter' [] ps = ps
          multipleFilter' (p:ns) ps
              | p >= (ceiling . sqrt . fromInteger) lim = (p:ps) ++ ns
              | otherwise = multipleFilter' (filter (\x -> x `mod` p /= 0) ns) (p:ps)
