# Check sequential test run

    Code
      head(TreeScan(count = diagnoses, tree = icd_10_se, p = 1 / 2,
      n_monte_carlo_sim = 10, random_seed = 1234), 10)
    Output
           cut n1 n0       llr p
       1: H722  4  1 0.9637238 1
       2: A169  3  1 0.5232481 1
       3: I979  3  1 0.5232481 1
       4: O060  3  1 0.5232481 1
       5: O743  3  1 0.5232481 1
       6: R443  3  1 0.5232481 1
       7: A280  2  1 0.1698990 1
       8: B085  2  1 0.1698990 1
       9: B159  2  1 0.1698990 1
      10: B378  2  1 0.1698990 1

# Check parallel test run

    Code
      head(TreeScan(count = diagnoses, tree = icd_10_se, p = 1 / 2,
      n_monte_carlo_sim = 20, random_seed = 124, future_control = list("multisession",
        workers = 2)), 10)
    Output
              cut  n1   n0      llr          p
       1:      20 420 2759 962.4608 0.04761905
       2:      19 400 2598 900.3181 0.04761905
       3: V01-X59 303 1868 627.3549 0.04761905
       4:      01 247 1606 556.9007 0.04761905
       5:      02 246 1570 538.4563 0.04761905
       6: V01-V99 258 1575 525.7399 0.04761905
       7:      17 178 1355 512.0843 0.04761905
       8:      13 153 1030 364.4017 0.04761905
       9: C00-C97 148  933 317.6328 0.04761905
      10:      14 120  855 312.1327 0.04761905

