test_that("Check sequential test run", {
  expect_snapshot({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              n_exposed = 1000,
              n_unexposed = 10000,
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
              n_exposed = 1000,
              n_unexposed = 10000,
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
              n_exposed = 1000,
              n_unexposed = 10000,
              dictionary = icd_10_se_dict,
              n_monte_carlo_sim = 20,
              random_seed = 124) |>
      head(10)
  })
})

test_that("Test out put if no number of individuals is specified", {
  expect_snapshot({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              dictionary = icd_10_se_dict,
              n_monte_carlo_sim = 20,
              random_seed = 124) |>
      head(10)
  })
})

test_that("Test return of test distribution", {
  expect_snapshot({
    temp <- TreeMineR(data = diagnoses,
                      tree  = icd_10_se,
                      p = 1/11,
                      dictionary = icd_10_se_dict,
                      n_monte_carlo_sim = 20,
                      random_seed = 124,
                      return_test_dist = TRUE)

    head(temp$test_dist, 10)

  })
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

test_that("Test n_exposed or n_unexposed <= 0",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(pathString = "1/KLM"),
              p = 1/11,
              n_exposed = -1,
              n_unexposed = 900,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "One of `n_exposed` and `n_unexposed` is less or equal to 0.")
})

test_that("Test n_exposed or n_unexposed <= 0",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(pathString = "1/KLM"),
              p = 1/11,
              n_exposed = 900,
              n_unexposed = 0,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "One of `n_exposed` and `n_unexposed` is less or equal to 0.")
})

test_that("Test n_exposed or n_unexposed <= 0",{
  expect_error({
    TreeMineR(data = data.frame(id = 1, leaf = "KLM", exposed = 0),
              tree  = data.frame(pathString = "1/KLM"),
              p = 1/11,
              n_exposed = 0,
              n_unexposed = 0,
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "One of `n_exposed` and `n_unexposed` is less or equal to 0.")
})

test_that("Test calculation of p based on n_exposed and n_unexposed",{
  expect_message({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              n_exposed = sum(diagnoses$exposed == 1),
              n_unexposed = sum(diagnoses$exposed == 0),
              n_monte_carlo_sim = 10,
              random_seed = 1234)
  }, regexp = "`p` is set to 0.13406")
})

test_that("Dictionary is not compatible with dictionary format",{
  expect_error({
    TreeMineR(data = diagnoses,
              tree  = icd_10_se,
              p = 1/11,
              n_exposed = 1000,
              n_unexposed = 10000,
              dictionary = icd_10_se_dict[,1],
              n_monte_carlo_sim = 1,
              random_seed = 1234)
  }, regexp = "I could not find your `title` and/or `node`")
})

