test_that("LLR is close to 0 if q0 = p",{
  expect_equal({

    calc_llr(data.table::data.table(cut = "AA1", n0 = 230, n1 = 23),
             no_iteration = 1, p = 0.1)[["llr"]]

  }, 0)
})
