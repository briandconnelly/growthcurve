#' Create a data frame from a fit
#'
#' \code{as.data.frame} creates a data frame that contains information about
#' the fit
#' 
#' @param x A fit for some growth data
#' @param row.names \code{NULL} or a character vector giving the row names for
#' the data frame. Missing values are not allowed. (ignored)
#' @param optional (ignored)
#' @param ... Additional arguments (ignored)
#'
#' @return A data frame containing the parameters for the fit
#' @export
#'
as.data.frame.gcfit <- function(x, row.names=NULL, optional=FALSE, ...) {
    data.frame(LagLength.Est = x$lag_length[[1]],
               LagLength.Err = x$lag_length[[2]],
               MaxRate.Est = x$max_rate[[1]],
               MaxRate.Err = x$max_rate[[2]],
               MaxGrowth.Est = x$max_growth[[1]],
               MaxGrowth.Err = x$max_growth[[2]],
               Integral = x$integral)
}
