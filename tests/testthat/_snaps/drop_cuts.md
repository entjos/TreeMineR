# Check return_removed = FALSE

    Code
      head(drop_cuts(tree = icd_10_se, cuts = c("B35-B49", "F41"), return_removed = FALSE))
    Output
        pathString
      1         01
      2         02
      3         03
      4         04
      5         05
      6         06

