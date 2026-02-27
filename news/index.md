# Changelog

## TreeMineR 1.0.4

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
