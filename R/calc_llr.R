calc_llr <- function(counts, no_iteration, p){

  n0 <- n1 <- q0 <- q1 <- ll0 <- lla <- llr <- iteration <- NULL

  counts[, q0 := n0 /(n0 + n1)]
  counts[, q1 := n1 /(n0 + n1)]

  counts[, lla := log(q1) * n1 + log(q0) * n0]
  counts[, ll0 := log(p)  * n1 + log(1 - p)  * n0]
  counts[, llr := lla - ll0]

  counts[, list(iteration = no_iteration, cut, n0, n1, llr)]

}
