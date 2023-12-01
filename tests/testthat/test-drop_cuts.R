test_that("Removing specific cuts from a tree",{
  expect_equal({
    temp <- drop_cuts(tree = icd_10_se,
                      cuts = c("B35-B49", "F41"),
                      return_removed = TRUE)

    length(temp$removed$F41)
  }, 7)
})

test_that("Check return tree does not include any removed elements",{
  expect_false({
    temp <- drop_cuts(tree = icd_10_se,
                      cuts = c("B35-B49", "F41"),
                      return_removed = TRUE)


    any(temp$removed$`B35-B49` %in% temp$tree$pathString)

  })
})

test_that("Check return_removed = FALSE",{
  expect_snapshot({
    drop_cuts(tree = icd_10_se,
              cuts = c("B35-B49", "F41"),
              return_removed = FALSE) |>
      head()

  })
})

test_that("Error when pathSting not found",{
  expect_error({
    drop_cuts(tree = data.frame(string = c("01/B35-B49/B46/B468",
                                           "01/B35-B49/B48/B481")),
              cuts = c("B35-B49", "F41"),
              return_removed = TRUE)
  }, "Could not find column `pathString` in `tree`")
})

test_that("Error when wrong delimiter is used",{
  expect_error({
    drop_cuts(tree = icd_10_se,
              cuts = c("B35-B49", "F41"),
              delimiter = ":",
              return_removed = TRUE)
  }, "I could not find any match for : in `pathString`")
})
