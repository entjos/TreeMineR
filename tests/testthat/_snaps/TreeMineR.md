# Check sequential test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, n_monte_carlo_sim = 10, random_seed = 1234), 10)
    Output
             cut  n1   n0 risk1  risk0       RR       llr          p
      1       12 122  669 0.122 0.0669 1.823617 16.187145 0.09090909
      2       11 132  782 0.132 0.0782 1.687980 13.657855 0.09090909
      3  V01-X59 241 1687 0.241 0.1687 1.428571 12.268163 0.09090909
      4  V01-V99 210 1438 0.210 0.1438 1.460362 11.957318 0.09090909
      5       15 133  822 0.133 0.0822 1.618005 11.797748 0.09090909
      6       19 306 2281 0.306 0.2281 1.341517 10.806142 0.09090909
      7       02 207 1452 0.207 0.1452 1.425620 10.423109 0.09090909
      8       18 114  712 0.114 0.0712 1.601124  9.711722 0.09090909
      9       01 207 1483 0.207 0.1483 1.395819  9.287006 0.09090909
      10      16 109  690 0.109 0.0690 1.579710  8.803335 0.09090909

# Check parallel test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, n_monte_carlo_sim = 20, random_seed = 124, future_control = list(
        "multisession", workers = 2)), 10)
    Output
             cut  n1   n0 risk1  risk0       RR       llr          p
      1       12 122  669 0.122 0.0669 1.823617 16.187145 0.04761905
      2       11 132  782 0.132 0.0782 1.687980 13.657855 0.04761905
      3  V01-X59 241 1687 0.241 0.1687 1.428571 12.268163 0.04761905
      4  V01-V99 210 1438 0.210 0.1438 1.460362 11.957318 0.09523810
      5       15 133  822 0.133 0.0822 1.618005 11.797748 0.09523810
      6       19 306 2281 0.306 0.2281 1.341517 10.806142 0.09523810
      7       02 207 1452 0.207 0.1452 1.425620 10.423109 0.09523810
      8       18 114  712 0.114 0.0712 1.601124  9.711722 0.09523810
      9       01 207 1483 0.207 0.1483 1.395819  9.287006 0.09523810
      10      16 109  690 0.109 0.0690 1.579710  8.803335 0.09523810

# Test the use of titles

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, dictionary = icd_10_se_dict, n_monte_carlo_sim = 20,
      random_seed = 124), 10)
    Output
                                                                                                                       title
      1                                                                           Hudens och underhudens sjukdomar (L00-L99)
      2                                                                            Matsmaltningsorganens sjukdomar (K00-K93)
      3                                                                                                           Olycksfall
      4                                                                                                     Transportolyckor
      5                                                                   Graviditet, forlossning och barnsangstid (O00-O99)
      6                                             Skador, forgiftningar och vissa andra foljder av yttre orsaker (S00-T98)
      7                                                                                                    Tumorer (C00-D48)
      8  Symtom, sjukdomstecken och onormala kliniska fynd och laboratoriefynd som ej klassificeras pa annan plats (R00-R99)
      9                                                             Vissa infektionssjukdomar och parasitsjukdomar (A00-B99)
      10                                                                                Vissa perinatala tillstand (P00-P96)
             cut  n1   n0 risk1  risk0       RR       llr          p
      1       12 122  669 0.122 0.0669 1.823617 16.187145 0.04761905
      2       11 132  782 0.132 0.0782 1.687980 13.657855 0.04761905
      3  V01-X59 241 1687 0.241 0.1687 1.428571 12.268163 0.04761905
      4  V01-V99 210 1438 0.210 0.1438 1.460362 11.957318 0.09523810
      5       15 133  822 0.133 0.0822 1.618005 11.797748 0.09523810
      6       19 306 2281 0.306 0.2281 1.341517 10.806142 0.09523810
      7       02 207 1452 0.207 0.1452 1.425620 10.423109 0.09523810
      8       18 114  712 0.114 0.0712 1.601124  9.711722 0.09523810
      9       01 207 1483 0.207 0.1483 1.395819  9.287006 0.09523810
      10      16 109  690 0.109 0.0690 1.579710  8.803335 0.09523810

# Test out put if no number of individuals is specified

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, dictionary = icd_10_se_dict,
      n_monte_carlo_sim = 20, random_seed = 124), 10)
    Output
                                                                                                                       title
      1                                                                           Hudens och underhudens sjukdomar (L00-L99)
      2                                                                            Matsmaltningsorganens sjukdomar (K00-K93)
      3                                                                                                           Olycksfall
      4                                                                                                     Transportolyckor
      5                                                                   Graviditet, forlossning och barnsangstid (O00-O99)
      6                                             Skador, forgiftningar och vissa andra foljder av yttre orsaker (S00-T98)
      7                                                                                                    Tumorer (C00-D48)
      8  Symtom, sjukdomstecken och onormala kliniska fynd och laboratoriefynd som ej klassificeras pa annan plats (R00-R99)
      9                                                             Vissa infektionssjukdomar och parasitsjukdomar (A00-B99)
      10                                                                                Vissa perinatala tillstand (P00-P96)
             cut  n1   n0       llr          p
      1       12 122  669 16.187145 0.04761905
      2       11 132  782 13.657855 0.04761905
      3  V01-X59 241 1687 12.268163 0.04761905
      4  V01-V99 210 1438 11.957318 0.09523810
      5       15 133  822 11.797748 0.09523810
      6       19 306 2281 10.806142 0.09523810
      7       02 207 1452 10.423109 0.09523810
      8       18 114  712  9.711722 0.09523810
      9       01 207 1483  9.287006 0.09523810
      10      16 109  690  8.803335 0.09523810

# Test return of test distribution

    Code
      temp <- TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, dictionary = icd_10_se_dict,
      n_monte_carlo_sim = 20, random_seed = 124, return_test_dist = TRUE)
      head(temp$test_dist, 10)
    Output
         iteration   max_llr
      1          2 12.208531
      2          3  5.039655
      3          4  6.866651
      4          5  5.097155
      5          6  7.184879
      6          7  5.149988
      7          8  5.039655
      8          9  5.963116
      9         10  5.534555
      10        11  5.777970

