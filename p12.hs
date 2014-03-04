-- Makes a list of prime factors in the form (factor, power)
-- This method is too damn slow because it finds all the primes below the number by sieving first.
primeFactors :: Integer -> [(Integer,Integer)]
primeFactors n = primeFactors' n (primesBelow n) []
    where primeFactors' :: Integer -> [Integer] -> [(Integer, Integer)] -> [(Integer, Integer)]
          primeFactors' n' [] factors = reverse factors
          primeFactors' n' (p:ps) factors
              | fromFactorization factors == n = factors
              | n' `mod` p /= 0 = primeFactors' n' ps factors
              | otherwise       = let (smallerNumber, factoredOut) = factorOut n'
                                  in primeFactors' smallerNumber ps (factoredOut:factors)
                  -- (the result of all the divisions, (prime factor, power))
                  where factorOut :: Integer -> (Integer, (Integer, Integer))
                        factorOut n''
                            | n'' `mod` p == 0 = let (smaller, (fact, power)) = factorOut $ n'' `div` p
                                                 in (smaller, (fact, power + 1))
                            | otherwise        = (n'', (p, 0))

fromFactorization :: [(Integer,Integer)] -> Integer
fromFactorization fs = product $ map (\(p,e) -> p ^ e) fs

multipleFilter :: Integer -> [Integer] -> [Integer]
multipleFilter _ [] = []
multipleFilter lim (p:ns) 
    | p >= (ceiling . sqrt . fromInteger) lim = p:ns
    | otherwise = p:(multipleFilter lim (filter (\x -> x `mod` p /= 0) ns))


-- Get all the prime numbers in a given range by using the sieve of Erastosthenes
primesBelow :: Integer -> [Integer]
primesBelow lim = multipleFilter lim [2..lim]

isTriangular :: Integer -> Bool
isTriangular n = (reverse $ takeWhile (\x -> x <= n) triangles) !! 0 == n

fibonacci :: Integer -> Integer
fibonacci n 
    | n == 1 = 1
    | otherwise = (+) n $ fibonacci (n - 1)

divisorCount :: Integer -> Integer
divisorCount n = product $ map (\(pf, ex) -> ex + 1) $ primeFactors n

triangles = map fibonacci [1..]

main = print $ take 1 $ filter (\n -> (divisorCount) n > 500) triangles
