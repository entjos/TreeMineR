## Description

This package is an R implementation of tree-based scan statistics as
described in [Kulldorff et al. (2013)](https://doi.org/10.1002/pds.3423)
or [Kulldorff et al. (2003)](https://doi.org/10.1111/1541-0420.00039).
To get started, please take a look at the
[vignette](https://entjos.github.io/TreeMineR/articles/Tree-based-scan-statistics.html)
or check the documentation of the main functions:

- [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
- [`create_tree()`](https://entjos.github.io/TreeMineR/reference/create_tree.md)
- `cut_the_tree()`

The package also includes the following pre-defined hierarchical trees,
which can be used out of the box. Please check their help files for more
information. - `icd_10_se` - `atc_codes`

## Installation

For installing the package from CRAN please use

``` r
install.packages("TreeMineR")
```

If you would like to use the latest development version from GitHub
please use

``` r
# install.packages("remotes")
remotes::install_github("entjos/TreeMineR")
```

## Bugs

If you find any bugs or have any suggestion please don’t hesitate to
file an issue on GitHub.
