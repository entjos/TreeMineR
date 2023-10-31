test_that("No double counting of events in leafs on the same path",
          {expect_equal({

            dfr <- data.table::data.table(id = 1,
                                          leaf = c("B260", "B261"),
                                          exposed = 0)

            temp <- cut_the_tree(data = dfr,
                                 icd_10_se,
                                 delimiter = "/")

            temp[temp$cut == "01"]$n0

            }, 1)
          })

test_that("Count events for each individual",
          {expect_equal({

            dfr <- data.table::data.table(id = 1:2,
                                          leaf = c("B260", "B261"),
                                          exposed = 0)

            temp <- cut_the_tree(data = dfr,
                                 icd_10_se,
                                 delimiter = "/")

            temp[temp$cut == "01"]$n0

          }, 2)
          })
