# TreeMineR 1.0.3

# TreeMineR 1.0.3

* Added a new vignette

# TreeMineR 1.0.2
* Added option to `TreeMineR()` for returning the test distribution of LLRs used for calculating the P-values.
* Fixed issues with the ATC tree included in the package. The previous version of the tree did only include ATC codes with a depth of at least 5 levels. The updated version includes also codes with a lower depth, e.g., `A02AH`, which only has a depth of 4 levels.

# TreeMineR 1.0.1

* Removed `data.table` from depend field in DESCRIPTION.
* Improved documentation
