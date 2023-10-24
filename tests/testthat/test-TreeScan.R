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

test_that("Check user defined cut points", {
  expect_equal({
    temp <- TreeScan(diagnoses,
                     exposure = case,
                     leafs = diag,
                     id = id,
                     cut_positions = c(1, 3),
                     random_seed = 1234,
                     n_monte_carlo_sim = 20,
                     future_control = list("multisession", workers = 2))

    unique(nchar(temp$cut))
  }, c(1, 3))
})

test_that("Check user defined cut points in random order",{
  expect_equal({
    temp <- TreeScan(diagnoses,
                     exposure = case,
                     leafs = diag,
                     id = id,
                     cut_positions = c(3, 1, 4),
                     random_seed = 1234,
                     n_monte_carlo_sim = 20,
                     future_control = list("multisession", workers = 2))

    unique(nchar(temp$cut))
  }, c(1, 3, 4))
})

test_that("Defining cuts longer than max(nchar(leaf)) causes an error",{
  expect_error({
    TreeScan(diagnoses,
             exposure = case,
             leafs = diag,
             id = id,
             cut_positions = c(3, 1, 5),
             random_seed = 1234,
             n_monte_carlo_sim = 20,
             future_control = list("multisession", workers = 2))
  }, regexp = "Your cut position\\(s\\) 5")
})



