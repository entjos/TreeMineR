# Counts is equal to expected numbers

    Code
      get_cuts(data.table(id = 1:10, diag = "A", case = rep(0:1, 5)), id = "id",
      exposure = "case", leafs = "diag", n_char = 1)
    Output
         cut n0 n1
      1:   A  5  5

