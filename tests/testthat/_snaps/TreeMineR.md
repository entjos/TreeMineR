# Check sequential test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, n_monte_carlo_sim = 10, random_seed = 1234), 10)
    Output
             cut  n1   n0 risk1  risk0       RR      llr          p
      1       12 127  674 0.127 0.0674 1.884273 18.52600 0.09090909
      2       19 337 2329 0.337 0.2329 1.446973 18.32574 0.09090909
      3  V01-X59 254 1708 0.254 0.1708 1.487119 15.78202 0.09090909
      4       02 221 1467 0.221 0.1467 1.506476 14.57499 0.09090909
      5  V01-V99 219 1453 0.219 0.1453 1.507226 14.47571 0.09090909
      6       11 134  784 0.134 0.0784 1.709184 14.47115 0.09090909
      7       20 333 2419 0.333 0.2419 1.376602 13.79084 0.09090909
      8       01 220 1498 0.220 0.1498 1.468625 12.87728 0.09090909
      9       15 134  828 0.134 0.0828 1.618357 11.89632 0.09090909
      10      18 117  717 0.117 0.0717 1.631799 10.71622 0.09090909

# Check parallel test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, n_monte_carlo_sim = 20, random_seed = 124, future_control = list(
        "multisession", workers = 2)), 10)
    Output
             cut  n1   n0 risk1  risk0       RR      llr          p
      1       12 127  674 0.127 0.0674 1.884273 18.52600 0.04761905
      2       19 337 2329 0.337 0.2329 1.446973 18.32574 0.04761905
      3  V01-X59 254 1708 0.254 0.1708 1.487119 15.78202 0.04761905
      4       02 221 1467 0.221 0.1467 1.506476 14.57499 0.04761905
      5  V01-V99 219 1453 0.219 0.1453 1.507226 14.47571 0.04761905
      6       11 134  784 0.134 0.0784 1.709184 14.47115 0.04761905
      7       20 333 2419 0.333 0.2419 1.376602 13.79084 0.04761905
      8       01 220 1498 0.220 0.1498 1.468625 12.87728 0.04761905
      9       15 134  828 0.134 0.0828 1.618357 11.89632 0.04761905
      10      18 117  717 0.117 0.0717 1.631799 10.71622 0.09523810

# Test the use of titles

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, n_exposed = 1000,
      n_unexposed = 10000, dictionary = icd_10_se_dict, n_monte_carlo_sim = 20,
      random_seed = 124), 10)
    Output
                                                                                                                       title
      1                                                                           Hudens och underhudens sjukdomar (L00-L99)
      2                                             Skador, forgiftningar och vissa andra foljder av yttre orsaker (S00-T98)
      3                                                                                                           Olycksfall
      4                                                                                                    Tumorer (C00-D48)
      5                                                                                                     Transportolyckor
      6                                                                            Matsmaltningsorganens sjukdomar (K00-K93)
      7                                                                         Yttre orsaker till sjukdom och dod (V01-Y98)
      8                                                             Vissa infektionssjukdomar och parasitsjukdomar (A00-B99)
      9                                                                   Graviditet, forlossning och barnsangstid (O00-O99)
      10 Symtom, sjukdomstecken och onormala kliniska fynd och laboratoriefynd som ej klassificeras pa annan plats (R00-R99)
             cut  n1   n0 risk1  risk0       RR      llr          p
      1       12 127  674 0.127 0.0674 1.884273 18.52600 0.04761905
      2       19 337 2329 0.337 0.2329 1.446973 18.32574 0.04761905
      3  V01-X59 254 1708 0.254 0.1708 1.487119 15.78202 0.04761905
      4       02 221 1467 0.221 0.1467 1.506476 14.57499 0.04761905
      5  V01-V99 219 1453 0.219 0.1453 1.507226 14.47571 0.04761905
      6       11 134  784 0.134 0.0784 1.709184 14.47115 0.04761905
      7       20 333 2419 0.333 0.2419 1.376602 13.79084 0.04761905
      8       01 220 1498 0.220 0.1498 1.468625 12.87728 0.04761905
      9       15 134  828 0.134 0.0828 1.618357 11.89632 0.04761905
      10      18 117  717 0.117 0.0717 1.631799 10.71622 0.09523810

# Test out put if no number of individuals is specified

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, dictionary = icd_10_se_dict,
      n_monte_carlo_sim = 20, random_seed = 124), 10)
    Output
                                                                                                                       title
      1                                                                           Hudens och underhudens sjukdomar (L00-L99)
      2                                             Skador, forgiftningar och vissa andra foljder av yttre orsaker (S00-T98)
      3                                                                                                           Olycksfall
      4                                                                                                    Tumorer (C00-D48)
      5                                                                                                     Transportolyckor
      6                                                                            Matsmaltningsorganens sjukdomar (K00-K93)
      7                                                                         Yttre orsaker till sjukdom och dod (V01-Y98)
      8                                                             Vissa infektionssjukdomar och parasitsjukdomar (A00-B99)
      9                                                                   Graviditet, forlossning och barnsangstid (O00-O99)
      10 Symtom, sjukdomstecken och onormala kliniska fynd och laboratoriefynd som ej klassificeras pa annan plats (R00-R99)
             cut  n1   n0      llr          p
      1       12 127  674 18.52600 0.04761905
      2       19 337 2329 18.32574 0.04761905
      3  V01-X59 254 1708 15.78202 0.04761905
      4       02 221 1467 14.57499 0.04761905
      5  V01-V99 219 1453 14.47571 0.04761905
      6       11 134  784 14.47115 0.04761905
      7       20 333 2419 13.79084 0.04761905
      8       01 220 1498 12.87728 0.04761905
      9       15 134  828 11.89632 0.04761905
      10      18 117  717 10.71622 0.09523810

# Test return of test distribution

    Code
      temp <- TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, dictionary = icd_10_se_dict,
      n_monte_carlo_sim = 20, random_seed = 124, return_test_dist = TRUE)
      head(temp$test_dist, 10)
    Output
         iteration   max_llr
      1          2 10.998093
      2          3  5.963116
      3          4  6.866651
      4          5  5.039655
      5          6  6.051306
      6          7  5.431785
      7          8  5.131699
      8          9  5.963116
      9         10  6.430469
      10        11  5.589140

