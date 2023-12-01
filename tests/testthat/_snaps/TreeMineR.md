# Check sequential test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11,
      n_monte_carlo_sim = 10, random_seed = 1234), 10)
    Output
              cut  n1   n0     risk1      risk0       RR       llr          p
       1:      12 122  669 0.1259030 0.07546531 1.668356 16.187145 0.09090909
       2:      11 132  782 0.1362229 0.08821207 1.544266 13.657855 0.09090909
       3: V01-X59 241 1687 0.2487100 0.19029893 1.306944 12.268163 0.09090909
       4: V01-V99 210 1438 0.2167183 0.16221094 1.336027 11.957318 0.09090909
       5:      15 133  822 0.1372549 0.09272420 1.480249 11.797748 0.09090909
       6:      19 306 2281 0.3157895 0.25730400 1.227301 10.806142 0.09090909
       7:      02 207 1452 0.2136223 0.16379019 1.304244 10.423109 0.09090909
       8:      18 114  712 0.1176471 0.08031585 1.464805  9.711722 0.09090909
       9:      01 207 1483 0.2136223 0.16728708 1.276980  9.287006 0.09090909
      10:      16 109  690 0.1124871 0.07783418 1.445215  8.803335 0.09090909

# Check parallel test run

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11,
      n_monte_carlo_sim = 20, random_seed = 124, future_control = list("multisession",
        workers = 2)), 10)
    Output
              cut  n1   n0     risk1      risk0       RR       llr          p
       1:      12 122  669 0.1259030 0.07546531 1.668356 16.187145 0.04761905
       2:      11 132  782 0.1362229 0.08821207 1.544266 13.657855 0.04761905
       3: V01-X59 241 1687 0.2487100 0.19029893 1.306944 12.268163 0.04761905
       4: V01-V99 210 1438 0.2167183 0.16221094 1.336027 11.957318 0.09523810
       5:      15 133  822 0.1372549 0.09272420 1.480249 11.797748 0.09523810
       6:      19 306 2281 0.3157895 0.25730400 1.227301 10.806142 0.09523810
       7:      02 207 1452 0.2136223 0.16379019 1.304244 10.423109 0.09523810
       8:      18 114  712 0.1176471 0.08031585 1.464805  9.711722 0.09523810
       9:      01 207 1483 0.2136223 0.16728708 1.276980  9.287006 0.09523810
      10:      16 109  690 0.1124871 0.07783418 1.445215  8.803335 0.09523810

# Test the use of titles

    Code
      head(TreeMineR(data = diagnoses, tree = icd_10_se, p = 1 / 11, dictionary = icd_10_se_dict,
      n_monte_carlo_sim = 20, random_seed = 124), 10)
    Output
                                                                                            title
       1:                                Vissa infektionssjukdomar och parasitsjukdomar (A00-B99)
       2:                                                                       Tumörer (C00-D48)
       3: Sjukdomar i blod och blodbildande organ samt vissa rubbningar i immunsystemet (D50-D89)
       4:       Endokrina sjukdomar, nutritionsrubbningar och ämnesomsättningssjukdomar (E00-E90)
       5:                        Psykiska sjukdomar och syndrom samt beteendestörningar (F00-F99)
       6:                                                      Sjukdomar i nervsystemet (G00-G99)
       7:                                        Sjukdomar i ögat och närliggande organ (H00-H59)
       8:                                         Sjukdomar i örat och mastoidutskottet (H60-H95)
       9:                                                Cirkulationsorganens sjukdomar (I00-I99)
      10:                                                    Andningsorganens sjukdomar (J00-J99)
          cut  n1   n0      risk1      risk0       RR        llr         p
       1:  01 207 1483 0.21362229 0.16728708 1.276980  9.2870063 0.0952381
       2:  02 207 1452 0.21362229 0.16379019 1.304244 10.4231090 0.0952381
       3:  03  49  360 0.05056760 0.04060914 1.245227  1.8956802 1.0000000
       4:  04 107  711 0.11042312 0.08020305 1.376795  7.0237236 0.2380952
       5:  05 114  747 0.11764706 0.08426396 1.396173  7.9647135 0.1428571
       6:  06  89  558 0.09184727 0.06294416 1.459186  7.4686450 0.1904762
       7:  07  60  419 0.06191950 0.04726452 1.310063  3.0926847 1.0000000
       8:  08  27  215 0.02786378 0.02425268 1.148895  0.5867027 1.0000000
       9:  09  98  626 0.10113519 0.07061478 1.432210  7.6290864 0.1904762
      10:  10  73  496 0.07533540 0.05595037 1.346468  4.3174359 1.0000000

# Test miss-specified delimiter

    Code
      TreeMineR(data = data.frame(id = 1:2, leaf = "KLM", exposed = 0:1), tree = data.frame(
        pathString = "1/KLM"), n_monte_carlo_sim = 10, random_seed = 1234)
    Message
      i p is set to 0.5.
    Condition
      Warning in `gmax()`:
      No non-missing values found in at least one group. Returning '-Inf' for such groups to be consistent with base
    Output
         cut n1 n0 risk1 risk0 RR llr          p
      1:   1  1  1     1     1  1   0 0.09090909
      2: KLM  1  1     1     1  1   0 0.09090909

