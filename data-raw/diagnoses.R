# Create example data set for tests

# Set random seed
set.seed(1)

# Sample diagnoses for unexposed
unexposed <- data.table::data.table(id = rep(1:10000, rbinom(10000, 10, 0.2)))
unexposed$diag <- comorbidity::sample_diag(n = nrow(unexposed))
unexposed$exposed <- 0

# Sample diagnoses for exposed
exposed <- data.table::data.table(id = 10000 + rep(1:1000, rbinom(1000, 10, 0.3)))
exposed$diag <- comorbidity::sample_diag(n = nrow(exposed))
exposed$exposed <- 1

# Combine datasets
diagnoses <- rbind(unexposed, exposed)

# Remove codes that are not included on in the ICD-10-SE
diagnoses <- diagnoses[diagnoses$diag %in% gsub(
  ".*(?<=\\/)(.*)", 
  "\\1",
  icd_10_se$pathString,
  perl = TRUE
  ), 
]

# Improve column names
colnames(diagnoses) <- c("id", "leaf", "exposed")

# Add dataset to package
usethis::use_data(diagnoses, overwrite = TRUE)
