cor2cov <- function(R, S) {
  sweep(sweep(R, 1, S, "*"), 2, S, "*")
}
