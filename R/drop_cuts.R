#' Remove cuts from your tree. This is, e.g., useful if you would like to
#' remove certain chapters from the ICD-10 tree used for the analysis as some
#' chapters might be a prior deemed irrelevant for the exposure of interest,
#' e.g., chapter 20 (external causes of death) might not be of interest
#' when comparing two drug exposures.
#'
#' @param tree
#'  A dataset with one variable `pathString` defining the tree structure
#'  that you would like to use. This dataset can, e.g., be created using
#'   \code{\link{create_tree}}.
#'
#' @param cuts
#'  A character vector of cuts to remove. Please make sure that your string
#'  uniquely identifies the cut that should be removed. Each string is passed
#'  to `base::gsub()` to identify the cuts that should be removed. Hence, strings
#'  can include regular expressions for identifying cuts. If you would like to
#'  remove a cut on the top level of the hierarchy, it might be helpful to use
#'  the regular expression operator `^`.
#'
#'  Regular expression are composed as follows:
#'  `paste0(cuts, delimiter, "?(.*)")`
#'
#' @param delimiter
#'  A character defining the delimiter of different tree levels within your
#'  `pathString`. The default is `/`.
#'
#' @param return_removed
#'  A logical value for indicating whether you would like to get a list of
#'  removed cuts returned by the function.
#'
#' @return
#'  If `return_removed = FALSE` a data.frame with a single variable named
#'  `pathString` is returned, which includes the updated tree. If
#'  `return_removed = TRUE` a list with two elements is return:
#'  \describe{
#'     \item{tree}{The updated tree file}
#'     \item{removed}{A list of character vectors including the paths that
#'     have been removed from the supplied tree. The list is named using the
#'     cuts supplied to `cut`.}
#'  }
#'
#' @examples
#' drop_cuts(icd_10_se, c("B35-B49", "F41")) |>
#'    head()
#'
#' @export drop_cuts

drop_cuts <- function(tree, cuts, delimiter = "/", return_removed = FALSE){

  # Test user input ------------------------------------------------------------

  if(!("pathString" %in% colnames(tree))) {
    cli::cli_abort(
      c(
        "x" = "Could not find column {.code pathString} in {.code tree}",
        "i" = "Please add pathString column to {.code tree}`"
      )
    )
  }

  if(!any(grepl(delimiter, tree$pathString, fixed = TRUE))){
    cli::cli_abort(
      c(
        "x" = "I could not find any match for {delimiter} in {.code pathString}.",
        "Are you sure you defined the right delimiter in your TreeMineR call?"
      )
    )
  }

  # Create regular expression for finding the cuts
  patterns   <- paste0(cuts, delimiter, "?(.*)")
  pathString <- tree$pathString

  out <- lapply(seq_along(patterns), function(i){

    temp <- pathString[!grepl(patterns[[i]], pathString)]

    # Print output if verbose
    if(return_removed){

      removed <- pathString[!(pathString %in% temp)]

    }

    pathString <<- temp

    if(return_removed){

      removed

    }

  })

  # return
  if(return_removed){

    list(tree    = data.frame(pathString = unique(pathString)),
         removed = stats::setNames(out, cuts))

  } else {

    data.frame(pathString = unique(pathString))

  }

}
