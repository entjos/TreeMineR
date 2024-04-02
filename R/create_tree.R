#' Creating a tree file for further use in [TreeMineR()].
#'
#' @param x A data frame that includes two or three columns:
#'    \describe{
#'      \item{`node`}{A string defining a node}
#'      \item{`parent`}{A string defining the partent of the node}
#'      }
#'
#' @return A data.frame with one variable `pathString` that describes the
#'   full path for each leaf included in the hierarchical tree.
#'
#' @import data.table
#' @export create_tree

create_tree <- function(x){

  # Declare variables used in data.table for R CMD check
  pathString <- parent <- dictionary <- NULL

  # Convert x to data.table
  x <- data.table::as.data.table(x)

  # Check input
  if(any(x[["node"]] == "", x[["parent"]] == "", na.rm = TRUE)){
    cli::cli_abort(
      c(
        "{.var node} and/or {.var parent} include empty cells",
        " " = "Please replace all empty cells with NAs."
      )
    )
  }

  # Do first merge of node and parents
  out <- merge(x,
               x,
               by.x = "node",
               by.y = "parent",
               all.y = TRUE)

  # Initialize counter
  i <- 1

  # Merge node and parent column until no children are left
  while (!all(is.na(out$parent))) {

    out <- merge(out,
                 x,
                 by.x = colnames(out)[[ncol(out)]],
                 by.y = "parent",
                 all.y = TRUE)

    colnames(out) <- c(paste0("child", i), colnames(out)[-1])

    i <- i + 1

  }

  # Cleaning up for outputting
  data.table::setcolorder(out, c(ncol(out), seq_len(ncol(out) -1)))
  out[, parent := NULL]

  # Create pathString that can be used for defining cuts
  out[, pathString := do.call(paste, c(.SD, sep = "/")),
      .SDcols = rev(colnames(out))]
  out[, pathString := gsub(".*\\/?NA\\/", "", pathString)]

  # Return
  as.data.frame(out[, "pathString"])

}
