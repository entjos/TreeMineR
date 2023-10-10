# Check sequential test run

    Code
      head(TreeScan(diagnoses, exposure = case, leafs = diag, id = id, random_seed = 1234,
        n_monte_carlo_sim = 10), 10)
    Output
          cut  n1  n0       llr          p
       1:   A 119 802 2.3993322 0.18181818
       2:   B 116 751 1.5048737 0.18181818
       3:   C 143 925 1.8356150 0.09090909
       4:   D 140 969 3.6229360 0.18181818
       5:   E 109 715 1.6497902 0.18181818
       6:   F 122 767 1.0698721 0.09090909
       7:   G  92 560 0.4717335 0.36363636
       8:   H  85 625 3.5527700 0.09090909
       9:   I 103 647 0.8920582 0.18181818
      10:   J  74 498 1.4706247 0.18181818

# Check parallel test run

    Code
      head(TreeScan(diagnoses, exposure = case, leafs = diag, id = id, random_seed = 1234,
        n_monte_carlo_sim = 20, future_control = list("multisession", workers = 2)),
      10)
    Output
          cut  n1  n0       llr          p
       1:   A 119 802 2.3993322 0.23809524
       2:   B 116 751 1.5048737 0.09523810
       3:   C 143 925 1.8356150 0.14285714
       4:   D 140 969 3.6229360 0.19047619
       5:   E 109 715 1.6497902 0.14285714
       6:   F 122 767 1.0698721 0.04761905
       7:   G  92 560 0.4717335 0.19047619
       8:   H  85 625 3.5527700 0.04761905
       9:   I 103 647 0.8920582 0.14285714
      10:   J  74 498 1.4706247 0.09523810

