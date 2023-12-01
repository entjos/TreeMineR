test_that("Check sequential test run", {
  expect_snapshot({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              use_dictionary = FALSE,
              n_monte_carlo_sim = 10,
              random_seed = 1234) |>
      head(10)
  })
})

test_that("Check parallel test run", {
  expect_snapshot({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              use_dictionary = FALSE,
              n_monte_carlo_sim = 20,
              random_seed = 124,
              future_control = list("multisession", workers = 2)) |>
      head(10)
  })
})

test_that("Test the use of titles", {
  expect_snapshot({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              use_dictionary = TRUE,
              n_monte_carlo_sim = 20,
              random_seed = 124) |>
      head(10)
  })
})

test_that("Test the use of titles", {
  expect_error({

    attr(icd_10_se, "dictionary") <- NULL

    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              use_dictionary = TRUE,
              n_monte_carlo_sim = 20,
              random_seed = 124)
  }, "I could not find your dictionary.")
})

test_that("Test that all leafs are included on your tree",{
  expect_error({
    TreeMineR(data = data.frame(id = 1,
                                leaf = c("KLM", "KLM"),
                                         exposed = 0),
              tree  = icd_10_se,
              p = 1/11,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "The following leafs are not included on your tree: KLM")
})

test_that("Test no clumn called leaf exisits in tree",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(leaf = "KLM", pathString = "1/KLM"),
              p = 1/11,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "includes a column named `leaf`, which is reserved by TreeMineR.")
})

test_that("Test no column pathString exisits in tree",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(path = "1/KLM"),
              p = 1/11,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "Could not find column `pathString` in `tree`")
})

test_that("Test miss-specified delimiter",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(pathString = "1-KLM"),
              p = 1/11,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "I could not find any match for / in `pathString`.")
})

test_that("Test miss-specified delimiter",{
  expect_snapshot({
    TreeMineR(data = data.frame(id = 1:2, leaf = "KLM", exposed = 0:1),
              tree  = data.frame(pathString = "1/KLM"),
              n_monte_carlo_sim = 10,
              use_dictionary = FALSE,
              random_seed = 1234)
  })
})


