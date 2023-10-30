test_that("Check sequential test run", {
  expect_snapshot({
    TreeScan(count = diagnoses,
             tree  = icd_10_se,
             p = 1/2,
             n_monte_carlo_sim = 10,
             random_seed = 1234) |>
      head(10)
  })
})

test_that("Check parallel test run", {
  expect_snapshot({
    TreeScan(count = diagnoses,
             tree  = icd_10_se,
             p = 1/2,
             n_monte_carlo_sim = 20,
             random_seed = 124,
             future_control = list("multisession", workers = 2)) |>
      head(10)
  })
})

test_that("Test that all leafs are included on your tree",{
  expect_error({
    TreeScan(count = data.frame(leaf = "KLM", n1 = 5, n0 = 2),
             tree  = icd_10_se,
             p = 1/2,
             n_monte_carlo_sim = 10,
             random_seed = 1234)
  }, regexp = "The following leafs are not included on your tree: KLM")
})

test_that("Test no clumn called leaf exisits in tree",{
  expect_error({
    TreeScan(count = data.frame(leaf = "KLM", n1 = 5, n0 = 2),
             tree  = data.frame(leaf = "KLM", pathString = "1/KLM"),
             p = 1/2,
             n_monte_carlo_sim = 10,
             random_seed = 1234)
  }, regexp = "includes a column named `leaf`, which is reserved by TreeScan.")
})

test_that("Test no clumn pathString exisits in tree",{
  expect_error({
    TreeScan(count = data.frame(leaf = "KLM", n1 = 5, n0 = 2),
             tree  = data.frame(path = "1/KLM"),
             p = 1/2,
             n_monte_carlo_sim = 10,
             random_seed = 1234)
  }, regexp = "Could not find column `pathString` in `tree`")
})

test_that("Test no clumn pathString exisits in tree",{
  expect_error({
    TreeScan(count = data.frame(leaf = "KLM", n1 = 5, n0 = 2),
             tree  = data.frame(pathString = "1-KLM"),
             p = 1/2,
             n_monte_carlo_sim = 10,
             random_seed = 1234)
  }, regexp = "I could not any match for / in `pathString`.")
})
