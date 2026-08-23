#' Obtaining the individual-to-cut membership table for `TreeMineR`
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
#' @return a data.table with one row per unique individual/cut combination
#'  \describe{
#'    \item{id}{The individual's id}
#'    \item{exposed}{The individual's exposure status}
#'    \item{cut}{The name of the cut the individual belongs to}
#'    }

get_cut_membership <- function(data,
                               tree,
                               delimiter){

  # Declare variables used in data.table for R CMD check
  pathString <- id <- exposed <- NULL

  # Check that data is not empty
  if(nrow(data) == 0) {
    cli::cli_abort(
      c(
        "x" = "{.code data} does not contain any rows.",
        "i" = "Please provide a {.code data} with at least one row."
      )
    )
  }

  # Extract leafs from pathString
  tree$leaf <- gsub(paste0(".*(?<=", delimiter, ")(.*)"), "\\1",
                    tree[["pathString"]],
                    perl = TRUE)

  # Check that leafs uniquely identify a position in the tree. Duplicated
  # leafs would otherwise make every individual with that leaf match all
  # tree rows sharing it, silently multiplying their events across branches.
  if(anyDuplicated(tree$leaf)) {
    cli::cli_abort(
      c(
        "x" = "The following leafs are duplicated across different branches
        of {.code tree}: {unique(tree$leaf[duplicated(tree$leaf)])}",
        "i" = "Each leaf must uniquely identify a single position in
        {.code tree}."
      )
    )
  }

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
  temp <- merge(data, tree, by = "leaf", all.x = TRUE)

  # Cut the pathString for each individual and leaf
  temp[, cut := strsplit(pathString, delimiter, fixed = TRUE)]
  temp <- temp[, list(cut = unlist(cut)), list(id, exposed)]

  # Include only unique cuts for each individual. This is important to
  # prevent that events get counted twice when they are on the same path
  # but on different leafs
  unique(temp, by = c("id", "cut"))

}
