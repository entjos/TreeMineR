# Remove cuts from your tree. This is, e.g., useful if you would like to remove certain chapters from the ICD-10 tree used for the analysis as some chapters might be a prior deemed irrelevant for the exposure of interest, e.g., chapter 20 (external causes of death) might not be of interest when comparing two drug exposures.

Remove cuts from your tree. This is, e.g., useful if you would like to
remove certain chapters from the ICD-10 tree used for the analysis as
some chapters might be a prior deemed irrelevant for the exposure of
interest, e.g., chapter 20 (external causes of death) might not be of
interest when comparing two drug exposures.

## Usage

``` r
drop_cuts(tree, cuts, delimiter = "/", return_removed = FALSE)
```

## Arguments

- tree:

  A dataset with one variable `pathString` defining the tree structure
  that you would like to use. This dataset can, e.g., be created using
  [`create_tree`](https://entjos.github.io/TreeMineR/reference/create_tree.md).

- cuts:

  A character vector of cuts to remove. Please make sure that your
  string uniquely identifies the cut that should be removed. Each string
  is passed to [`base::gsub()`](https://rdrr.io/r/base/grep.html) to
  identify the cuts that should be removed. Hence, strings can include
  regular expressions for identifying cuts. If you would like to remove
  a cut on the top level of the hierarchy, it might be helpful to use
  the regular expression operator `^`.

  Regular expression are composed as follows:
  `paste0(cuts, delimiter, "?(.*)")`

- delimiter:

  A character defining the delimiter of different tree levels within
  your `pathString`. The default is `/`.

- return_removed:

  A logical value for indicating whether you would like to get a list of
  removed cuts returned by the function.

## Value

If `return_removed = FALSE` a data.frame with a single variable named
`pathString` is returned, which includes the updated tree. If
`return_removed = TRUE` a list with two elements is return:

- tree:

  The updated tree file

- removed:

  A list of character vectors including the paths that have been removed
  from the supplied tree. The list is named using the cuts supplied to
  `cut`.

## Examples

``` r
drop_cuts(icd_10_se, c("B35-B49", "F41")) |>
   head()
#>             pathString
#> 1 ICD-10-SE/01/A00-A09
#> 2 ICD-10-SE/01/A15-A19
#> 3 ICD-10-SE/01/A20-A28
#> 4 ICD-10-SE/01/A30-A49
#> 5 ICD-10-SE/01/A50-A64
#> 6 ICD-10-SE/01/A65-A69
```
