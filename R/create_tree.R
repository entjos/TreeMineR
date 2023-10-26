#' Creating a tree file for further use in TreeScan
#'
#' @param x A data frame that includes two columns:
#'    \describe{
#'      \item{node}
#'      \item{parent}
#'    }
#'
#' @import data.table
#' @export

create_tree <- function(x){

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
  data.table::setcolorder(out, c("node.y", colnames(out)[-ncol(out)]))
  out[, parent := NULL]
  colnames(out) <- c("child", paste0("parent", seq_len(ncol(out) - 1)))

  # Create pathString that can be used for defining cuts
  out[, pathString := do.call(paste, c(.SD, sep = "/")),
      .SDcols = rev(colnames(out))]
  out[, pathString := gsub(".*\\/NA\\/", "", pathString)]

  # Return out
  as.data.frame(out)
}
