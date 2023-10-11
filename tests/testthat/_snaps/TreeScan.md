# Check sequential test run

    Code
      head(TreeScan(diagnoses, exposure = case, leafs = diag, id = id, random_seed = 1234,
        n_monte_carlo_sim = 10), 10)
    Output
          cut  n1   n0      llr          p
       1:   V 219 1453 356.3486 0.09090909
       2:   S 196 1204 331.8915 0.09090909
       3:   Q 171 1273 261.3530 0.09090909
       4:   T 165 1254 249.2604 0.09090909
       5:   C 143  925 235.7993 0.09090909
       6:   M 146  997 233.9520 0.09090909
       7:   L 127  675 230.8408 0.09090909
       8:   K 134  796 230.7656 0.09090909
       9:   O 134  828 226.2281 0.09090909
      10:   D 140  969 222.7180 0.09090909

# Check parallel test run

    Code
      head(TreeScan(diagnoses, exposure = case, leafs = diag, id = id, random_seed = 1234,
        n_monte_carlo_sim = 20, future_control = list("multisession", workers = 2)),
      10)
    Output
          cut  n1   n0      llr          p
       1:   V 219 1453 356.3486 0.04761905
       2:   S 196 1204 331.8915 0.04761905
       3:   Q 171 1273 261.3530 0.04761905
       4:   T 165 1254 249.2604 0.04761905
       5:   C 143  925 235.7993 0.04761905
       6:   M 146  997 233.9520 0.04761905
       7:   L 127  675 230.8408 0.04761905
       8:   K 134  796 230.7656 0.04761905
       9:   O 134  828 226.2281 0.04761905
      10:   D 140  969 222.7180 0.04761905

