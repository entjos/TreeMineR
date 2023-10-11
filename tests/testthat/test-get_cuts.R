test_that("Counts is equal to expected numbers",
          {expect_snapshot({
            get_cuts(data.table(id = 1:10,
                                diag = "A",
                                case = rep(0:1, 5)),
                     id = "id",
                     exposure = "case",
                     leafs = "diag",
                     n_char = 1)})
          })




