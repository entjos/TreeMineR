# Unconditional Bernoulli Tree-Based Scan Statistics for R

Unconditional Bernoulli Tree-Based Scan Statistics for R

## Usage

``` r
TreeMineR(
  data,
  tree,
  p = NULL,
  n_exposed = NULL,
  n_unexposed = NULL,
  dictionary = NULL,
  delimiter = "/",
  n_monte_carlo_sim = 9999,
  random_seed = FALSE,
  return_test_dist = FALSE,
  future_control = list(strategy = "sequential")
)
```

## Arguments

- data:

  The dataset used for the computation. The dataset needs to include the
  following columns:

  `id`

  :   An integer that is unique to every individual.

  `leaf`

  :   A string identifying the unique diagnoses or leafs for each
      individual.

  `exposed`

  :   A 0/1 indicator of the individual's exposure status. Exposure
      status must be constant within ids, i.e., an individual can either
      be exposed or unexposed.

  See below for the first and last rows included in the example dataset.

      id   leaf exposed
       1   K251       0
       2   Q702       0
       3    G96       0
       3   S949       0
       4   S951       0
      ---
      10999   V539       1
      10999   V625       1
      10999   G823       1
      11000    L42       1
      11000   T524       1

- tree:

  A dataset with one variable `pathString` defining the tree structure
  that you would like to use. This dataset can, e.g., be created using
  [`create_tree`](https://entjos.github.io/TreeMineR/reference/create_tree.md).

- p:

  The proportion of exposed individuals in the dataset. Will be
  calculated based on `n_exposed`, and `n_unexposed` if both are
  supplied.

- n_exposed:

  Number of exposed individuals (Optional).

- n_unexposed:

  Number of unexposed individuals (Optional).

- dictionary:

  A `data.frame` that includes one `node` column and a `title` column,
  which are used for labeling the cuts in the output of `TreeMineR`.

- delimiter:

  A character defining the delimiter of different tree levels within
  your `pathString`. The default is `/`.

- n_monte_carlo_sim:

  The number of Monte-Carlo simulations to be used for calculating
  P-values.

- random_seed:

  Random seed used for the Monte-Carlo simulations.

- return_test_dist:

  If `true`, a data.frame of the maximum log-likelihood ratios in each
  Monte Carlo simulation will be returned. This distribution of the
  maximum log-likelihood ratios is used for estimating the P-value
  reported in the result table.

- future_control:

  A list of arguments passed
  [`future::plan`](https://future.futureverse.org/reference/plan.html).
  This is useful if one would like to parallelise the Monte-Carlo
  simulations to decrease the computation time. The default is a
  sequential run of the Monte-Carlo simulations.

## Value

A `data.frame` with the following columns:

- `cut`:

  The name of the cut G.

- `n1`:

  The number of exposed events belonging to cut G.

- `n1`:

  The number of inexposed events belonging to cut G.

- `risk1`:

  The absolute risk of getting an event belonging to cut G among the
  exposed.

- `risk0`:

  The absolute risk of getting an event belonging to cut G among the
  unexposed.

- `RR`:

  The risk ratio of the absolute risk among the exposed over the
  absolute risk among the unexposed

- `llr`:

  The log-likelihood ratio comparing the observed and expected number of
  exposed events belonging to cut G.

- `p`:

  The P-value that cut G is a cluster of events.

If `return_test_dist` is `true` the function returns a list of two
data.frame.

- `result_table`:

  A data.frame including the results as described above.

- `test_dist`:

  A data.frame with two columns: `iteration` the number of the Monte
  Carlo iteration. Note that iteration is the calculation based on the
  original data and is, hence, not included in this data.fame.
  `max_llr`: the highest observed log-likelihood ratio for each Monte
  Carlo simulation

## References

Kulldorff et al. (2003) A tree-based scan statistic for database disease
surveillance. Biometrics 56(2): 323-331. DOI: 10.1111/1541-0420.00039.

## Examples

``` r
TreeMineR(data = diagnoses,
          tree  = icd_10_se,
          p = 1/11,
          n_monte_carlo_sim = 99,
          random_seed = 1234) |>
  head()
#>       cut  n1   n0      llr    p
#> 1      12 127  674 18.52600 0.01
#> 2      19 337 2329 18.32574 0.01
#> 3 V01-X59 254 1708 15.78202 0.01
#> 4      02 221 1467 14.57499 0.01
#> 5 V01-V99 219 1453 14.47571 0.01
#> 6      11 134  784 14.47115 0.01
```
