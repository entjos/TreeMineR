get_cuts <- function(data,
                     id,
                     exposure,
                     leafs,
                     n_char){

  ..id <- ..exposure <- ..leafs <- NULL

  cuts <- data[, list(id       = get(..id),
                      exposure = get(..exposure),
                      cut      = substr(get(..leafs), 1, n_char))] |>
    unique()

  cuts  <- cuts[, list(n = .N), by = list(exposure, cut)]

  data.table::dcast(cuts, "cut ~ paste0('n', exposure)",
                    value.var = "n",
                    fill = 0)

}
