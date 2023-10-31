test_that("Check that correctness of tree",
          {expect_equal({
            create_tree(data.frame(node  = c("01", "A", "AB"),
                                   parent = c(NA, "01", "A")))[[1]]
            }, c("01", "01/A", "01/A/AB"))
          })


