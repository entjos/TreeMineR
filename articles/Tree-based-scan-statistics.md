# Tree Based Scan Statistics

This vignette aims to give a short intoduction on how to use this
package to run tree-based scan statistics in R. Tree-based scan
statistic is a data driven method for identifying clusters of events
across a hierarchical tree. This could, e.g., be disease clusters across
the ICD-10 tree. This method is commonly used in pharmacovigilance to
identify potential side effects of drugs, using an agnostic approach.
Before we get started, let’s just define some terminology:

- **Leaf** is the most detailed code that is available for an event,
  e.g., the most detailed ICD-10 code for a diagnosis.
- **Hierarchical structure** is a system consisting of different nodes
  in which each node has at least one parent node, except for the root
  node.
- **Cut** is any node between the leaf node and the root node.

Please check [Kulldorff et al. (2013)](https://doi.org/10.1002/pds.3423)
for a more detailed description of the method. Let’s load the
`TreeMineR` package to get started.

``` r
library(TreeMineR)
```

The `TreeMineR` package comes with the `diagnosis` data set which
includes simulated diagnosis data on some exposed and unexposed
individuals. In order to use the `TreeMineR` function, we need to
prepare the data in a special format. Each row in our data set needs to
correspond to one diagnosis with information on which individual
received this diagnosis and whether the individual was exposed or
unexposed. The diagnosis dataset, is fortunately, already in the right
format. Let’s have a look:

``` r
diagnoses
#>           id   leaf exposed
#>        <num> <char>   <num>
#>     1:     1   K251       0
#>     2:     2   Q702       0
#>     3:     3    G96       0
#>     4:     3   S949       0
#>     5:     4   S951       0
#>    ---                     
#> 22985: 10999   V539       1
#> 22986: 10999   V625       1
#> 22987: 10999   G823       1
#> 22988: 11000    L42       1
#> 22989: 11000   T524       1
```

Besides our diagnosis data, we also need an object that defines our
hierarchical tree. This data frame includes a variable called
`pathString`, which defines the full path for each leaf. Let’s look at
an example. The `pathString` for the ICD-10 code B369 looks as follows:
the code is part of the group B36, which in turn is part of the block
B35-B49, which in turn is part of the ICD-10 chapter 1, which in turn is
part of the ICD-10-SE coding system. The full path, hence, is
`ICD-10-SE/01/B35-B49/B36/B369`. Important is, that each of the leafs
included in the data also has one row in the tree. E.g., if we have an
observation with a diagnosis code B36, we also need to add a row to the
tree file which finishes with B36, i.e., `ICD-10-SE/01/B35-B49/B36`.

The ICD-10-SE, is already included in the TreeMineR package and can be
used out of the box. If you want to use another tree structure, take a
look at the `create_tree` function, which makes it easy to define new
tree structures. Also the `drop_cuts` function can be useful if you want
to remove some leafs from your tree. This is, e.g., helpful in
situations, where you *a priori* want to remove some ICD-10 chapters
from your analysis.

Let’s have a look at the first rows of the ICD-10-SE tree file:

``` r
head(icd_10_se)
#>             pathString
#> 1 ICD-10-SE/01/A00-A09
#> 2 ICD-10-SE/01/A15-A19
#> 3 ICD-10-SE/01/A20-A28
#> 4 ICD-10-SE/01/A30-A49
#> 5 ICD-10-SE/01/A50-A64
#> 6 ICD-10-SE/01/A65-A69
```

Once we have the tree file defined and the data in the right format, we
can use the
[`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
function to identify potential event clusters. The
[`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md)
function has an inbuild parallelisation via the future package, which
can be set up using the `future_control` argument.

Let’s do a test run:

``` r
 TreeMineR(
  data = diagnoses,
  tree  = icd_10_se,
  p = 1/11,
  n_exposed = 1000,
  n_unexposed = 10000,
  n_monte_carlo_sim = 20,
  random_seed = 124,
  future_control = list("sequential")
  ) |> head()
#>       cut  n1   n0 risk1  risk0       RR      llr          p
#> 1      12 127  674 0.127 0.0674 1.884273 18.52600 0.04761905
#> 2      19 337 2329 0.337 0.2329 1.446973 18.32574 0.04761905
#> 3 V01-X59 254 1708 0.254 0.1708 1.487119 15.78202 0.04761905
#> 4      02 221 1467 0.221 0.1467 1.506476 14.57499 0.04761905
#> 5 V01-V99 219 1453 0.219 0.1453 1.507226 14.47571 0.04761905
#> 6      11 134  784 0.134 0.0784 1.709184 14.47115 0.04761905
```

In our data, we could identify three event clusters (Ch. 12, Ch. 11,
V01-X59) which passed the p \< 0.05 threshold, suggesting that exposed
individuals have a higher risk of being diagnosed with these disease
groups than unexposed individuals. Usually, you would like to increase
the number of Monte Carlo simulation runs to increase the stability of
the results.
