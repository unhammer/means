means
=====

[![Hackage](https://img.shields.io/hackage/v/means.svg?style=flat)](http://hackage.haskell.org/package/means)
[![Travis-CI](https://travis-ci.org/winterland1989/means.svg)](https://travis-ci.org/winterland1989/means)

This package provide following mean calculations using semigroup:

+ Arithmetic/ Weighted Arithmetic mean:

![AM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/6a2a249444267483a65897c33b045613e238bd0d)

+ Geometric mean:

![GM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/4e4f47c36a4852c6919089a709ed3738460b9b17)

+ Harmonic mean:

![HM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/53baf18a961ebb4aa823ffcb534002954a993e0f)

+ Quadratic mean(RMS):

![QM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/bb6d0d08bcd6e0d5ecb642f7f843591743993adc)

+ Cubic mean:

![CM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/87ea526bc6b48f6abb52bc522d57c9fedacbaf90)

+ Midrange mean:

![MM](https://en.wikipedia.org/api/rest_v1/media/math/render/svg/b554f5873aca205738f447d576c43e934dbaab62)

Check [wikipedia](https://en.wikipedia.org/wiki/Average) for details.

Example
-------

```haskell
*Data.Semigroup.Means> getAM . foldr1 (<>) . map am $ [4, 36, 45, 50, 75]
42.0
*Data.Semigroup.Means> getGM . foldr1 (<>) . map gm $ [4, 36, 45, 50, 75]
30.000000000000007
*Data.Semigroup.Means> getHM . foldr1 (<>) . map hm $ [4, 36, 45, 50, 75]
15.0
*Data.Semigroup.Means> :m + Data.Ratio
*Data.Semigroup.Means Data.Ratio> getMM . foldr1 (<>) . map mm $ [4, 36, 45, 50, 75] :: Ratio Int
79 % 2
*Data.Semigroup.Means Data.Ratio> getAM . foldr1 (<>) . map am $ [4, 36, 45, 50, 75] :: Ratio Int
42 % 1
```
