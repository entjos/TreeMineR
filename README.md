
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TreeMineR

<!-- badges: start -->

[![R-CMD-check](https://github.com/entjos/TreeMineR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/entjos/TreeMineR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/entjos/TreeMineR/branch/master/graph/badge.svg)](https://app.codecov.io/gh/entjos/TreeMineR?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/TreeMineR)](https://CRAN.R-project.org/package=TreeMineR)
<!-- badges: end -->

Implementation of tree-based scan statistics as described in [Kulldorff
et al. (2013)](https://doi.org/10.1002/pds.3423) or [Kulldorff et
al. (2003)](https://doi.org/10.1111/1541-0420.00039). To get started,
please take a look at the
[vignette](https://entjos.github.io/TreeMineR/articles/Tree-based-scan-statistics.html)
or check the documentation of the main functions:

- `TreeMineR()`
- `create_tree()`
- `cut_the_tree()`

The package also includes the following pre-defined hierarchical trees,
which can be used out of the box. Please check their help files for more
information.

- `icd_10_se`
- `atc_codes`

## Installation

You can install the development version of TreeMineR from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("entjos/TreeMineR")
```
