# Changelog

## TreeMineR (development version)

- Fixed Monte Carlo P-value calculation in
  [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md).
  Simulated maximum log-likelihood ratios (LLRs) equal to the observed
  LLR are now counted as at least as extreme as the observed value (`>=`
  instead of `>`), as required for a valid Monte Carlo P-value.
  Previously, ties were excluded, which inflated the family-wise type-I
  error rate, particularly for sparse count data with many possible ties
  ([\#9](https://github.com/entjos/TreeMineR/issues/9)).

- Fixed `calc_llr()` so that nodes in which every individual is exposed
  (or every individual is unexposed) no longer get an undefined (`NaN`)
  log-likelihood ratio. Such nodes were previously dropped from both the
  simulated reference distribution and the reported results, which could
  bias P-values ([\#9](https://github.com/entjos/TreeMineR/issues/9)).

- Added a check to
  [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
  which now throws an error if `p` is not greater than 0 and smaller
  than 1. `p = 0` or `p = 1` made the log-likelihood ratio degenerate
  (`Inf`) for all nodes containing exposed, respectively unexposed,
  individuals.

- Monte Carlo simulations in
  [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
  now preserve the correlation between related cuts. Exposure is
  simulated once per individual and re-aggregated through the tree,
  rather than resampling every cut independently, so a parent cut’s
  simulated count is now mechanically consistent with its children’s, as
  it is in the observed data
  ([\#10](https://github.com/entjos/TreeMineR/issues/10)).

- Added a check which now throws an error if `data` does not contain any
  rows, and if `tree` contains leafs that are duplicated across
  different branches. Both previously caused an uninformative error from
  internal `data.table` operations.

## TreeMineR 1.0.4

CRAN release: 2026-02-27

- Fixed issue in the example dataset: The example dataset included
  individuals with non-constant exposure status, i.e., individuals who
  were at the same time exposed and unexposed. This should not be
  allowed. The example dataset has been updated accordingly.

- Added a check to the TreeMineR function which now throws an error if
  exposure status is not constant within ids.

## TreeMineR 1.0.3

CRAN release: 2025-04-05

- Added a new vignette

## TreeMineR 1.0.2

CRAN release: 2024-08-27

- Added option to
  [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
  for returning the test distribution of LLRs used for calculating the
  P-values.
- Fixed issues with the ATC tree included in the package. The previous
  version of the tree did only include ATC codes with a depth of at
  least 5 levels. The updated version includes also codes with a lower
  depth, e.g., `A02AH`, which only has a depth of 4 levels.

## TreeMineR 1.0.1

CRAN release: 2024-04-02

- Removed `data.table` from depend field in DESCRIPTION.
- Improved documentation
