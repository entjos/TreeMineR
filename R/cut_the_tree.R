#' Obtaining the number of events in different cuts for `TreeMineR`
#'
#' This is an internal function requiered for `TreeMineR`.
#'
#' @noRd
#'
#' @param data a data.table passed to TreeMineR
#'
#' @param tree a hirachical tree passed to TreeMineR
#'
#' @param delimiter a delimiter passed to TreeMineR
#'
#' @return a data.table with the following columns
#'  \describe{
#'    \item{cut}{The name of the cut}
#'    \item{n0}{The number of events belonging to the cut among unexposed individuals}
#'    \item{n1}{The number of events belonging to the cut among exposed individuals}
#'    }

cut_the_tree <- function(data,
                         tree,
                         delimiter){

  # Declare variables used in data.table for R CMD check
  pathString <- id <- exposed <- NULL

  # Extract leafs from pathString
  tree$leaf <- gsub(paste0(".*(?<=", delimiter, ")(.*)"), "\\1",
                    tree[["pathString"]],
                    perl = TRUE)

  # Check that all leafs in data are included on the tree
  if(any(!(data$leaf %in% tree$leaf))) {
    cli::cli_abort(
      c(
        "x" = "The following leafs are not included on your tree:
        {unique((data$leaf[!(data$leaf %in% tree$leaf)]))}",
        "i" = "All leafs must be included in your tree."
      )
    )
  }

  # Combine data and tree
  temp <- merge(data,
                tree,
                by = "leaf",
                all.x = TRUE)

  # Cut the pathString for each individual and leaf
  temp[, cut := strsplit(pathString, delimiter, fixed = TRUE)]
  temp <- temp[, list(cut = unlist(cut)), list(id, exposed)]

  # Include only unique cuts for each individual. This is important to
  # prevent that events get counted twice when they are on the same path
  # but on different leafs
  temp <- unique(temp, by = c("id", "cut"))

  # Calculate number of exposed and unexposed within each cut
  temp[, list(n0 = sum(exposed == 0), n1 = sum(exposed == 1)),
       by = "cut"]

}
