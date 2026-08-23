test_that("Error when data does not contain any rows",{
  expect_error({

    dfr <- data.table::data.table(id = integer(0),
                                  leaf = character(0),
                                  exposed = numeric(0))

    get_cut_membership(data = dfr,
                       icd_10_se,
                       delimiter = "/")

  }, regexp = "`data` does not contain any rows.")
})

test_that("Error when leafs are duplicated across different branches of tree",{
  expect_error({

    tree <- data.frame(pathString = c("root/A/X", "root/B/X"))

    dfr <- data.table::data.table(id = 1:2,
                                  leaf = c("X", "X"),
                                  exposed = 0)

    get_cut_membership(data = dfr,
                       tree,
                       delimiter = "/")

  }, regexp = "The following leafs are duplicated across different branches")
})

test_that("No double counting of events in leafs on the same path",
          {expect_equal({

            dfr <- data.table::data.table(id = 1,
                                          leaf = c("B260", "B261"),
                                          exposed = 0)

            temp <- get_cut_membership(data = dfr,
                                       icd_10_se,
                                       delimiter = "/")

            nrow(temp[temp$cut == "01"])

            }, 1)
          })

test_that("A parent cut's membership is the union of its children's membership",
          {expect_equal({

            tree <- data.frame(pathString = c("root/A/A1", "root/A/A2", "root/B"))

            dfr <- data.table::data.table(id = 1:6,
                                          leaf = rep(c("A1", "A2", "B"), each = 2),
                                          exposed = 0)

            membership <- get_cut_membership(dfr, tree, delimiter = "/")

            sort(membership[membership$cut == "A"]$id)

          }, c(1, 2, 3, 4))
          })

test_that("Simulated exposure counts aggregated through the membership table preserve the correlation between a parent cut and its non-overlapping children",
          {expect_true({

            tree <- data.frame(pathString = c("root/A/A1", "root/A/A2", "root/B"))

            dfr <- data.table::data.table(id = 1:60,
                                          leaf = rep(c("A1", "A2", "B"), each = 20),
                                          exposed = 0)

            membership <- get_cut_membership(dfr, tree, delimiter = "/")

            set.seed(1)
            simulated_exposed <- stats::setNames(stats::rbinom(60, 1, 0.3), 1:60)

            counts <- membership[, list(n1 = sum(simulated_exposed[as.character(id)])),
                                 by = "cut"]

            counts[counts$cut == "A"]$n1 ==
              counts[counts$cut == "A1"]$n1 + counts[counts$cut == "A2"]$n1

          })
          })
