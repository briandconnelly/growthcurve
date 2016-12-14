#' Construct a Single Row Summary of a Growth Model or Fit
#' 
#' Currently, this function simply wraps \code{glance.nls} or
#' \code{glance.smooth.spline}, so parametric fits such as
#' \code{fit_growth_logistic} and \code{fit_growth_gompertz} cannot be compared
#' with results from \code{fit_growth_spline}. This function does not work with
#' results from \code{fit_growth_loess}.
#' 
#' @note This function requires the \pkg{broom} package.
#'
#' @inheritParams tidy.growthcurve
#' @return a single-row data frame or NULL
#' @export
#'
#' @examples
#' \dontrun{
#' myfit <- fit_growth_gompertz(mydata, Time, OD600)
#' glance(myfit)}
#'
glance.growthcurve <- function(x, ...) {
    stop_without_package("broom")
    broom::glance(x$model, ...)
}
