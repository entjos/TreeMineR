# Check return_removed = FALSE

    Code
      head(drop_cuts(tree = icd_10_se, cuts = c("B35-B49", "F41"), return_removed = FALSE))
    Output
                  pathString
      1 ICD-10-SE/01/A00-A09
      2 ICD-10-SE/01/A15-A19
      3 ICD-10-SE/01/A20-A28
      4 ICD-10-SE/01/A30-A49
      5 ICD-10-SE/01/A50-A64
      6 ICD-10-SE/01/A65-A69

