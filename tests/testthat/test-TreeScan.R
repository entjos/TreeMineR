test_that("Check sequential test run", {
  expect_snapshot({
    TreeScan(diagnoses,
             exposure = case,
             leafs = diag,
             id = id,
             random_seed = 1234,
             n_monte_carlo_sim = 10) |>
      head(10)
  })
})

test_that("Check parallel test run", {
  expect_snapshot({
    TreeScan(diagnoses,
             exposure = case,
             leafs = diag,
             id = id,
             random_seed = 1234,
             n_monte_carlo_sim = 20,
             future_control = list("multisession", workers = 2)) |>
      head(10)
  })
})

